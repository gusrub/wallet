module Cards

  class CreateCardService

    attr_reader :output, :errors, :messages, :card_params

    def initialize(card_params, user)
      @errors = []
      @messages = []
      @card_params = card_params
      @user = user
    end

    def perform
      # clear old data
      @output = nil
      @errors.clear
      @messages.clear

      card_args = {
        last_4: card_params[:number].last(4),
        expiration: Date.parse("#{card_params[:expiration_year]}/#{card_params[:expiration_month]}/01"),
        card_type: card_params[:card_type],
        issuer: card_params[:issuer]
      }

      @card = @user.cards.build(card_args)

      if @card.valid?
        # TODO: implement a method that exchanges card info for a token
        # that we'll use to store only necessary info and remove automatic
        # token generation of has_secure_token
        # @card.token = generate_bank_token
        @card.save!
        @output = @card
      else
        @errors << @card.errors.full_messages
      end

      @errors.empty?
    end

  end
end
