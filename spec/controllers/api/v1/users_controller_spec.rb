require 'spec_helper'

describe Api::V1::UsersController do

  describe "GET #show" do
    before(:each) do
      @user = FactoryBot.create :user, active: false
      @user.update(username: "#{FFaker::Internet.user_name}#{Random.rand(1000).to_s}", active: true)
      get :show, params: {id: @user.id}
    end

    it "returns information about the user" do
      user_response = json_response[:data][:attributes]
      expect(user_response[:username]).to eql @user.username
    end

    it { should respond_with 200 }
  end

  #Ben 6/17/2018 Dont need to test for creation anymore because that will be handled during registration
  # describe "POST #create" do
	# context "when is successfully created" do
	#   before(:each) do
	# 	@user_attributes = FactoryBot.attributes_for :user
	#  	post :create, { user: @user_attributes }
	#   end
  #
	#   it "renders the json representation for the user record just created" do
	# 	user_response = json_response[:data][:attributes]
	# 	expect(user_response[:email]).to eql @user_attributes[:email]
	#   end
  #
	#   it {should respond_with 201 }
	# end
  #
	# context "when is not created" do
	# 	before(:each) do
	# 		#notice no email is provided
	# 		@invalid_user_attributes = { password: "12345678", password_confirmation: "12345678" }
	# 		post :create, { user: @invalid_user_attributes }
	# 	end
  #
	# 	it "renders an errors json" do
	# 		user_response = json_response
	# 		expect(user_response).to have_key(:errors)
	# 	end
  #
	# 	it "renders the json errors on why the user could not be created" do
	# 		user_response = json_response
	# 		expect(user_response[:errors][:email]).to include "can't be blank"
	# 	end
  #
	# 	it { should respond_with 422}
	# end
  #
  # end
describe "PUT/PATCH #update" do
    context "when update is attempted after the first update" do
      before do
        @user = FactoryBot.create :user
        @user.update(username: "#{FFaker::Internet.user_name}#{Random.rand(1000).to_s}", active: true)
        api_authorization_header @user
      end

      context "when username is not updated because it is not the first update on that user record" do
        before do
          @original_username = @user.username
          patch :update, params: { id: @user.id,
                           user: { username: 'TinyTim' } }, format: :json
        end

        it "renders the json representation for the updated user, which includes the original username" do
          user_response = json_response[:data][:attributes]
          expect(user_response[:username]).to eql @original_username
        end

        it { should respond_with 200 }
      end
    end


    context "when first update is attempted" do
      context "and update fails" do
        before(:each) do
          @user = FactoryBot.create :user, active: false
          api_authorization_header @user
        end

        context "because username is nil" do
          before do
            patch :update, params: { rspec_test: "because username is nil", id: @user.id, user: { active: true, username: nil } }, format: :json
          end

          it "renders an errors json" do
            user_response = json_response
            expect(user_response).to have_key(:errors)
          end

          it "renders the json errors on why the user could not be created" do
            user_response = json_response
            expect(user_response[:errors]).to include "you must set a unique username"
          end

          it { is_expected.to respond_with 422 }
        end

        context "because username is a duplicate" do
before do
            @user2 = FactoryBot.create :user, active: false
            @user2.update_column(:username, "first_username")
            patch :update, params: { rspec_test: "because username is duplicate", id: @user.id, user: { active: true, username: @user2.username } }, format: :json
          end

          it "renders an errors json" do
            user_response = json_response
            expect(user_response).to have_key(:errors)
          end

          it "renders the json errors on why the user could not be created" do
            user_response = json_response
            expect(user_response[:errors][:username]).to include "has already been taken"
          end

          it { is_expected.to respond_with 422 }
        end
      end
    end
  end
end
