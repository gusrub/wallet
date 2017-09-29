class ApplicationController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound do |error|
    error_response = {
      level: "warning",
      message: "No #{error.model} found with ID '#{error.id}'",
      data: nil
    }
    error_response[:data] = error if Rails.env.development? || Rails.env.test?
    render json: error_response, status: 404
  end

  # rescue_from StandardError do |error|
  #   error_response = {
  #     level: "error",
  #     message: "There has been an internal system error",
  #     data: nil
  #   }
  #   error_response[:data] = error if Rails.env.development? || Rails.env.test?
  #   render json: error_response, status: 500
  # end

  def paginate(resource)
    response.set_header("X-Total-Pages", resource.pages)
    if params[:page].present?
      resource.page(params[:page].to_i)
    else
      resource.page(1)
    end
  end

end
