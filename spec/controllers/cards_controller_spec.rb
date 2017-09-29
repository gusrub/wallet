require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe CardsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Card. As you add validations to Card, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      "name_on_card": "John Doe",
      "number": "4111111111111111",
      "csc": "123",
      "expiration_year": "2020",
      "expiration_month": "06",
      "card_type": "credit",
      "issuer": "visa"
    }
  }

  let(:invalid_attributes) {
    {
      "name_on_card": nil,
      "number": nil,
      "csc": nil,
      "expiration_year": nil,
      "expiration_month": nil,
      "card_type": nil,
      "issuer": nil
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CardsController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  let(:user) { FactoryGirl.create(:user) }
  let(:params) { { format: :json, user_id: user.id } }

  describe "GET #index" do
    let!(:resource) { FactoryGirl.create_list(:user_with_cards, 5) }
    subject { get :index, params: params, session: valid_session }
    it_behaves_like "paginated endpoint"
    it "returns a success response" do
      subject
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      card = FactoryGirl.create(:card, user: user)
      get :show, params: params.merge({id: card.to_param}), session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Card" do
        expect {
          post :create, params: params.merge({card: valid_attributes}), session: valid_session
        }.to change(Card, :count).by(1)
      end

      it "renders a JSON response with the new card" do

        post :create, params: params.merge({card: valid_attributes}), session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(user_cards_url(Card.last.user, Card.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new card" do

        post :create, params: params.merge({card: invalid_attributes}), session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested card" do
      card = FactoryGirl.create(:card, user: user)
      expect {
        delete :destroy, params: params.merge({id: card.to_param}), session: valid_session
      }.to change(Card, :count).by(-1)
    end
  end

end
