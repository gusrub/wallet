RSpec.shared_context "authenticated user" do |role|
  let(:authenticated_user) { FactoryGirl.create(:user, role: User.roles[role.to_sym]) }
  let(:authentication_token) { FactoryGirl.create(:token, user: authenticated_user,token_type: Token.token_types[:authentication]) }
  before :each do
    @request.headers["X-User-Email"] = authenticated_user.email,
    @request.headers["X-User-Token"] = authentication_token.token
  end
end
