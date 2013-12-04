class ClientsController < ApplicationController
  # GET /clients
  def index
    @clients = current_user.clients
  end

  # GET /clients/new
  def new
    @client = current_user.clients.new
  end

  # POST /clients
  def create
    @client = Client.new(client_params)
    @client.user = current_user

    if @client.save
      redirect_to clients_url
    else
      render :new
    end
  end

  private

  def client_params
    params.require(:client).permit(:name)
  end
end
