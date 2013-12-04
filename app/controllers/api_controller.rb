class ApiController < ApplicationController
  # API doesn't keep session data.
  protect_from_forgery with: :null_session

  # API doesn't require authentication.
  skip_before_filter :authenticate!

  # Render failure message if some mandatory parameter is missing.
  rescue_from Exceptions::APIParameterMissing do |exception|
    render json: { status: 'failure', error_code: exception.error_code, description: exception.message }
  end

  # Ensures required parameters are present in request.
  #
  # @param [Array] required_params Array of symbols to check for in request params.
  def require_params(required_params)
    required_params.each do |required_param|
      raise Exceptions::APIParameterMissing, "Required parameter '#{required_param}' is missing" if params[required_param].nil?
    end
  end
end
