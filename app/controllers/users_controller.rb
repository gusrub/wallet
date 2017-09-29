class UsersController < ApplicationController

  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = paginate(User.all)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # POST /users
  # POST /users.json
  def create
    # TODO: move this to a service
    @user = User.new(create_user_params)
    @user.build_account(balance: 0, account_type: Account.account_types[:customer])

    if @user.save
      render :show, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(update_user_params)
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def create_user_params
      params.require(:user).permit(:email, :password, :first_name, :last_name, :role, :status)
    end

    def update_user_params
      params.require(:user).permit(:first_name, :last_name, :role, :status)
    end
end
