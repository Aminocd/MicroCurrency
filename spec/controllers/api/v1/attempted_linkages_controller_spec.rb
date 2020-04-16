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
        attempted_linkage_response = json_response
        expect(attempted_linkage_response[:errors][0][:detail]).to include "You need to sign in"
      end

      it { should respond_with 401 }
    end
  end  

  describe "POST #create" do
    context "when the currency exists" do
      context "when the currency hasn't been claimed" do
        before(:each) do
          @user = FactoryBot.create :user
          api_authorization_header @user
          post :create, params: { attempted_linkage: { currency_id_external_key: 10 } }
        end

        it "renders the json representation of the attempted_linkage record just created" do
          attempted_linkage_response = json_response[:data][:attributes]
          expect(attempted_linkage_response[:"user-id"]).to eql @user.id
        end

        it { should respond_with 201 }
      end

      context "when the currency has already been claimed" do
        before(:each) do
          # create attempted_linkage using the FactoryBot with the default values that include :currency_id_external_key being set to 10
          @attempted_linkage = FactoryBot.create :attempted_linkage
          @user = @attempted_linkage.user

          # create a new user so that the second attempted_linkage belongs to a different user than the first
          @user2 = FactoryBot.create :user

          # call the #check_transactions_for_confirmation_value(user_id) method of the claimed_currency object associated with the first attempted_linkage in order to have user that created the first attempted_linkage claim that currency
          @attempted_linkage.claimed_currency.check_transactions_for_confirmation_value(@user.id)

          # POST #create with user2 to attempt to create an attempted_linkage to the claimed_currency claimed in the last step
          api_authorization_header @user2

          post :create, params: { attempted_linkage: { currency_id_external_key: 10 } }
        end

        it "returns a json error" do  
          attempted_linkage_response = json_response
          expect(attempted_linkage_response[:errors][:currency][0]).to include "currency is already claimed"
        end

        it { should respond_with 422 }
      end
    end
  end
end
