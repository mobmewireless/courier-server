class Message < ActiveRecord::Base
  validates :content,   presence: true
  validates :device_id, presence: true
  validates :client_id, presence: true

  belongs_to :device
  belongs_to :client

  # Available and valid status values.
  STATES = { pending: 'pending', success: 'successful', fail: 'failed' }
  # Provide status helper scopes.
  STATES.each_value { |s| scope :"all_#{s}", lambda { where('status = ?', s) } }

  def self.send_message(message, access_token, device_name=nil)
    # Find the client which is sending the message.
    client = Client.find_by(access_token: access_token)

    raise Exceptions::ClientNotFound unless client

    # The user client's user.
    user = client.user

    # Figure out which devices are supposed to get the messages.
    devices = if device_name
      device = user.devices.find_by(name: device_name)

      raise Exceptions::DeviceNotFound unless device

      [device]
    else
      user.devices
    end

    # Now let's create the message entries.
    devices.each do |device|
      client.messages.create!(
        device: device,
        content: message
      )
    end
  end
end
