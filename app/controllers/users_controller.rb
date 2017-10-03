class UsersController < ApplicationController

  load_and_authorize_resource
  skip_load_resource only: :create

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
    service = Users::CreateUserService.new(create_params)

    if service.perform
      @user = service.output
      render :show, status: :created, location: service.output
    else
      render json: service.errors, status: :unprocessable_entity
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
    service = Users::DeleteUserService.new(@user)

    if service.perform
      head :no_content
    else
      render json: service.errors, status: :bad_request
    end
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
