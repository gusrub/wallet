require 'rails_helper'

RSpec.describe "Cards", type: :request do
  let(:params) { {format: :json} }
  describe "GET /cards" do
    it "works! (now write some real specs)" do
      user = FactoryGirl.create(:user)
      get user_cards_path user, params
      expect(response).to have_http_status(200)
    end
  end
end
