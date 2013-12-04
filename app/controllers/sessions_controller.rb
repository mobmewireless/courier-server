class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token if Rails.env.development?
  skip_before_filter :authenticate!

  def create
    unless COURIER_CONFIG[:allowed_users].include?(auth_hash.info[:email])
      @email = auth_hash.info[:email]
      return
    end

    user = User.find_or_create_by(email: auth_hash.info[:email])
    @current_user_session = UserSession.create(user)

    redirect_to root_url
  end

  def destroy
    current_user_session.try(:destroy)
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
