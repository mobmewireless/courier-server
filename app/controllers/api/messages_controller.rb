class Api::MessagesController < ApiController
  # POST /messages
  def send_message
    require_params [:message, :access_token]

    begin
      Message.send_message(params[:message], params[:access_token])
    rescue Exceptions::ClientNotFound => e
      render json: { status: 'failure', error_code: e.error_code, description: 'Could not authenticate access token.' } and return
    end

    render json: { status: 'success', description: 'Message has been pushed to all user devices.' }
  end
end
