require 'spec_helper'

describe Api::V1::AttemptedLinkagesController, type: :controller do
  describe "GET #show" do
    context "when the correct authorization token is provided" do
      before(:each) do
        @attempted_linkage = FactoryBot.create :attempted_linkage
        @user = @attempted_linkage.user
        api_authorization_header @user
        get :show, params: { id: @attempted_linkage.id }
      end

      it "returns information about the attempted_linkage" do
        attempted_linkage_response = json_response[:data][:attributes]
        expect(attempted_linkage_response[:"claimed-currency-id"]).to eql @attempted_linkage.claimed_currency.id
      end

      it "returns the user that created the attempted_linkage" do
        attempted_linkage_response = json_response[:data][:attributes]
        expect(attempted_linkage_response[:"user-id"]).to eql @attempted_linkage.user.id
      end

      it { should respond_with 200 }
    end

    context "when an incorrect authorization token is provided" do
      before(:each) do
        @attempted_linkage = FactoryBot.create :attempted_linkage
        api_authorization_header "bogus_token"
        get :show, params: { id: @attempted_linkage.id }
      end

      it "returns error message" do
        puts "\n\n\nattempted_linkage_response: #{json_response.inspect}\n\n\n"
        attempted_linkage_response = json_response
        expect(attempted_linkage_response[:errors][0][:detail]).to include "You need to sign in"
      end

      it { should respond_with 401 }
    end
  end  
end
