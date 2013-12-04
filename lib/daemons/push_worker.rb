require_relative 'daemon_helper'

class PushWorker
  attr_reader :logger

  # Initializes logger, hi_gcm client and establish database connection.
  def initialize
    @logger = COURIER_CONFIG['logger'] || Logger.new(STDOUT)
    connect_db! #see daemon_helper.rb
  end

  # Actual daemon logic goes here
  def run
    logger.info 'starting push worker'

    loop do
      messages = Message.all_pending
      logger.info "Found #{messages.count} message(s)."
      messages.each do |message|
        gcm_push(message)
      end
      sleep 10
    end
  end

  # Send a message to the reg_id using HiGCM::Sender.
  #
  # @return [Hash] response body as hash.
  def hi_gcm_send(reg_id, message)
    @hi_gcm ||= HiGCM::Sender.new(COURIER_CONFIG['gcm_api_key'])
    JSON.parse @hi_gcm.send(reg_id, message).body # interested only in the body section.
  end


  # Push a message to google cloud messaging server.
  #
  # @param [Message] message The message to be sent.
  def gcm_push(message)
    device_push_id = [message.device.push_id] # higcm requires this to be an array.
    push_message = { :data => { :mesg =>message.content } }
    logger.info "Pushing message to gcm message id: #{message.id}, content => #{push_message}"
    response = hi_gcm_send(device_push_id, push_message)
    update_message_status message, response
  end

  # Updates the status of a message with response status.
  #
  # @param [Message] message The message to be updated.
  # @param [Hash] response The response returned by the hi_gcm client.
  # @see PushWorker#hi_gcm_send
  def update_message_status(message, response)
    logger.info "Got response from gcm: #{response}"
    message.meta = response.to_json
    status = gcm_status_from response, message.device
    logger.info "Marking message(id: #{message.id}) status as #{status.to_s}"
    message.status = status
    message.save
  end

  # Creates a status string by parsing the response against google provided templates.
  # There is a special case where response status is successful but also contains a registration id.
  # In such cases the existing device registration id should be replaced with the one gcm returned.
  #
  # @see http://developer.android.com/google/gcm/gcm.html#example-requests
  #
  # @param [String] response
  # @param [Device] device
  #
  # @example How this works?
  #   {'multicast_id'=>'multi_cast_id', 'success'=>1, 'failure'=>0, 'canonical_ids'=>0,
  #       'results'=>[{'message_id'=>'1:0408' }]} #=> success
  #
  #   {'multicast_id'=>'multi_cast_id', 'success'=>0, 'failure'=>1, 'canonical_ids'=>0,
  #       'results'=>[{'error'=>'NotRegistered'}]} #=> failed
  #
  #   {'multicast_id'=>'multi_cast_id', 'success'=>0, 'failure'=>1, 'canonical_ids'=>0,
  #       'results'=>[{'error'=>'Unavailable'}]} #=> pending
  #
  #   {'multicast_id'=>'multi_cast_id', 'success'=>1, 'failure'=>0, 'canonical_ids'=>1,
  #       'results'=>[{'message_id'=>'1:0408', 'registration_id'=> 'B232' }]} #=> success
  #
  # @return [String] status can be success, pending or fail
  def gcm_status_from(response, device)
    status = if response['failure'] == 1
      result = response['results'][0]['error']
      case result
        when 'Unavailable' then :pending #TODO should apply exponential back-off, raising the sleep time might help.
        when 'NotRegistered' then :fail
      end
    elsif response['canonical_ids'] == 1
      new_reg_id = response['results'][0]['registration_id']
      device.push_id = new_reg_id
      device.save
      :success
    else
      :success
    end
    Message::STATES[status]
  end
end

# Entry point
if __FILE__ == $0
  PushWorker.new().run
end