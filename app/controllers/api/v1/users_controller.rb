class Api::V1::UsersController < APIController
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead
	# protect_from_forgery with: :null_session #Ben 6/19/2018 Dont need this set here since it is inhereitgn from the APIController which declares protect from forgery there.

	before_action only: [:update, :destroy] do
		authenticate_user!
	end

	def show
    user = User.find(params[:id])
    if current_user == user
      render json: user, serializer: Api::V1::AuthorizedUserSerializer
    else
		  render json: user, serializer: Api::V1::UserSerializer
    end
	end

	def create
		user = User.new(user_params)
		if user.save
			render json: user, status: 201, location: [:api, user], serializer: Api::V1::AuthorizedUserSerializer
		else
			render json: { errors: user.errors }, status: 422
		end
	end

	def update
		user = current_user

    # unless the 'active' field is being changed from false to true, and username is not set in the database, do update without validating that username param is provided. Otherwise execute the else block that ensures that username param is provided and valid
    unless active_being_set_to_true? && username_unset_in_db?
      if user.update(user_params_update)
        render json: user, serializer: Api::V1::AuthorizedUserSerializer, status: 200, location: [:api, user]
      else
        render json: { errors: user.errors}, status: 422
      end
    else
      # first activation: ensure username param is provided and valid
      if username_param_provided_and_valid?
        if user.update(user_params_first_update)
          render json: user, serializer: Api::V1::AuthorizedUserSerializer, status: 200, location: [:api, user]
        else
          render json: { errors: user.errors }, status: 422
        end
      else
        render json: { errors: "you must set a unique username in the update that first sets your user account's 'active' field to true" }, status: 422
      end
    end
	end

	def destroy
		current_user.destroy
		head 204
	end

  protected
    def active_being_set_to_true?
      # byebug
      unless params[:user].nil?
        new_active_state = params[:user][:active].to_s
        old_active_state = User.find(params[:id]).active.to_s
        if (new_active_state == "true" && old_active_state == "false")
          true
        else
          false
        end
      else
        false
      end
    end

    def username_unset_in_db?
      # byebug
      username_db = User.find(params[:id]).username

      if username_db.nil?
        true
      else
        false
      end
    end

    def username_param_provided_and_valid?
      username_param = params[:user][:username]

      unless username_param.nil?
        true
      else
        false
      end
    end

	private
		def user_params_create
			params.require(:user).permit(:email, :password, :password_confirmation)
		end

    def user_params_update
      params.require(:user).permit(:active) 
    end

    def user_params_first_update
      params.require(:user).permit(:active, :username) 
    end
end
