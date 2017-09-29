class CardsController < ApplicationController
  before_action :set_user
  before_action :set_card, only: [:show, :update, :destroy]

  # GET /cards
  # GET /cards.json
  def index
    # TODO: put this in a service and scope it depending on the user role:
    # @cards = if current_user.admin?
    #           @user.cards
    #          else
    #            @user.cards.active
    #          end
    @cards = paginate(@user.cards)
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
  end

  # POST /cards
  # POST /cards.json
  def create
    # TODO: do this in a service and also validate card
    card_params = {
      last_4: create_card_params[:number].last(4),
      expiration: Date.parse("#{create_card_params[:expiration_year]}/#{create_card_params[:expiration_month]}/01"),
      card_type: create_card_params[:card_type],
      issuer: create_card_params[:issuer]
    }

    @card = @user.cards.build(card_params)

    if @card.save
      render :show, status: :created, location: user_cards_url(@card.user, @card)
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    # TODO: put this in a service and do not destroy but disable if there
    # are transactions:
    # if Transaction.where(transactionable: @card).exists?
    #   @card.removed!
    # else
    #   @card.destroy
    # end
    @card.destroy
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_card
    @card = @user.cards.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def create_card_params
    params.require(:card).permit([
      :name_on_card,
      :number,
      :csc,
      :expiration_year,
      :expiration_month,
      :card_type,
      :issuer
    ])
  end
end
