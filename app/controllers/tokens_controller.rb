class TokensController < ApplicationController

  before_action :set_token, only: :show

  # POST /tokens
  # POST /tokens.json
  def create
    @token = Token.new(token_params.except(:user))
    @token.user = User.find_by(email: token_params.fetch(:user).fetch(:email)) if token_params[:user].present?

    if @token.save
      render :show, status: :created, location: @token
    else
      render json: @token.errors, status: :unprocessable_entity
    end
  end

  def show

  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def token_params
      params.require(:token).permit(:token_type, user: [:email, :password])
    end

    def set_token
      @token = Token.find(params.fetch(:id))
    end
end
