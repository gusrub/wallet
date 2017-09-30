class TransactionsController < ApplicationController
  before_action :set_user
  before_action :set_transaction, only: :show

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = paginate(@user.transactions)
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # POST /transactions
  # POST /transactions.json
  def create
    # TODO: Move this to a service
    transferable_id = create_transaction_params[:transferable][:id]
    @transaction = @user.transactions.build(create_transaction_params.except(:transferable))

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

  def set_user
    @user = User.find(params[:user_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def create_transaction_params
    params.require(:transaction).permit(:amount, :transaction_type, :description, transferable: :id)
  end
end
