require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:params) { {format: :json} }
  describe "GET /users" do
    it "works! (now write some real specs)" do
      get users_path params
      expect(response).to have_http_status(200)
    end
  end
end
