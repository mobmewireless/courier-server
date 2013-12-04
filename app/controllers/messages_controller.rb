class MessagesController < ApplicationController
  def index
    @messages = if params.include?(:device_id)
      current_user.devices.find_by(id: params[:device_id])
    else
      current_user.clients.find_by(id: params[:client_id])
    end.messages

    render :list
  end

  def list
    @messages = current_user.messages
  end
end