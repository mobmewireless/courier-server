class Api::DevicesController < ApiController
  # GET /sender_id
  def sender_id
    render json: { status: 'success', sender_id: COURIER_CONFIG[:gcm_project_number] }
  end

  # POST /register
  def register
    require_params [:token, :push_id]

    begin
      Device.register(params[:token], params[:push_id])
    rescue Exceptions::DeviceNotFound => e
      render json: { status: 'failure', error_code: e.error_code, description: 'Could not find a device with the supplied token.' } and return
    end

    render json: { status: 'success', description: 'Device push identifier has been registered.' }
  end

  # POST /:device_name/messages
  def send_message
    require_params [:message, :access_token]

    begin
      Message.send_message(params[:message], params[:access_token], params[:device_name])
    rescue Exceptions::ClientNotFound => e
      render json: { status: 'failure', error_code: e.error_code, description: 'Could not authenticate access token.' } and return
    rescue Exceptions::DeviceNotFound => e
      render json: { status: 'failure', error_code: e.error_code, description: 'Could not find a device with the supplied name.' } and return
    end

    render json: { status: 'success', description: 'Message has been pushed to device.' }
  end
end
