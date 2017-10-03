class TransactionsController < ApplicationController

  load_and_authorize_resource :user
  load_and_authorize_resource through: :user
  skip_load_resource only: :create

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = paginate(@transactions)
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # POST /transactions
  # POST /transactions.json
  def create
    # TODO: Move this to a service
    transferable_id = create_params[:transferable][:id]
    @transaction = @user.transactions.build(create_params.except(:transferable))

    @transaction.transferable = if @transaction.transfer?
                                  Account.find(transferable_id)
                                elsif @transaction.deposit? || @transaction.withdrawal?
                                  @user.cards.find(transferable_id)
                                else
                                # raise an error
                                end

    @transaction.description ||= "#{@transaction.transaction_type.humanize} to #{@transaction.transferable.user.email}"
    @transaction.user_balance ||= 0
    @transaction.transferable_balance ||= 0

    if @transaction.save
      render :show, status: :created, location: user_transaction_url(@transaction.user, @transaction)
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end


  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def create_params
    params.require(:transaction).permit(:amount, :transaction_type, :description, transferable: :id)
  end
end
