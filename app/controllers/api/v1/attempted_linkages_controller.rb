class Api::V1::AttemptedLinkagesController < ApplicationController
	before_action only: [:create] do
		authenticate_user!
	end

  def create
    if current_user.active == false 
      render json: { errors: "logged in user is inactive"}, status: 422
    else
      final_params = attempted_linkage_params
      final_params[:user_id] = current_user.id # get logged in user's ID

      attempted_linkage = AttemptedLinkage.build(final_params)

      if attempted_linkage.save
        render json: attempted_linkage, status: 201, location: [:api, attempted_linkage]
      else
        render json: { errors: attempted_linkage.errors}, status: 422
      end
    end
  end

  private
    def attempted_linkage_params
      params.require(:attempted_linkage).permit(:currency_id_external_key)
    end
end
