class DevicesController < ApplicationController
  # GET /devices
  def index
    @devices = current_user.devices
  end

  # GET /devices/new
  def new
    @device = current_user.devices.new(device_type: 'android')
  end

  # POST /devices
  def create
    @device = current_user.devices.new(device_params)

    if @device.save
      redirect_to device_url(@device)
    else
      render :new
    end
  end

  # GET /devices/:id
  def show
    @device = Device.find(params[:id])

    unless @device
      # TODO: Render a 404 unless the device exists.
      #render :404
      #return
    end

    @host = request.host
    @port = request.port

    render :show_unready unless @device.registered?
  end

  # POST /devices/:id/send_message
  def send_message
    device = Device.find(params[:id])

    current_user.default_client.send_message(params[:message], device)

    flash[:notice] = 'Your message has been successfully pushed to the device.'
    redirect_to device_url(device)
  end

  private

  def device_params
    params[:device][:device_type] = 'android'
    params[:device].permit(:name, :device_type)
  end
end
