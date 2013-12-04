class UsersController < ApplicationController
  def index
    @stats = {
      device_count: current_user.devices.count,
      registered_device_count: current_user.devices.where('push_id IS NOT NULL').count,
      client_count: current_user.clients.count,
      message_count: current_user.messages.count
    }
  end
end
