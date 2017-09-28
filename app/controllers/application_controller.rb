class ApplicationController < ActionController::API

  rescue_from StandardError do |error|
    error_response = {
      level: "error",
      message: "There has been an internal system error",
      data: nil
    }
    error_response[:data] = error if Rails.env.development? || Rails.env.test?
    render json: error_response, status: 500
  end

end
