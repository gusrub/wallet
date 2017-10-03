class UsersController < ApplicationController

  load_and_authorize_resource

  # GET /users
  # GET /users.json
  def index
    @users = paginate(@users)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # POST /users
  # POST /users.json
  def create
    # TODO: move this to a service
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
    if @user.update(update_params)
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
  # Never trust parameters from the scary internet, only allow the white list through.
  def create_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :role, :status)
  end

  def update_params
    params.require(:user).permit(:first_name, :last_name, :role, :status)
  end
end
