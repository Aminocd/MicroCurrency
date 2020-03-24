class Api::V1::AttemptedReallocationsController < APIController
	before_action only: [:show, :index, :create] do
		authenticate_user!
	end

  def show
    attempted_reallocation = current_user.attempted_reallocations.find(params[:id])

    render json: attempted_reallocation
  end

  def index
    if current_user.active == true
      # all active attempted_reallocations of the user
      if params[:claimed_currency_id].nil?
        attempted_reallocations = current_user.attempted_reallocations.where(active: true).reverse
      else
      # all active attempted_reallocations of the user for the claimed_currency specified by the claimed_currency_id param
        claimed_currency = ClaimedCurrency.find(params[:claimed_currency_id])
        attempted_reallocations = current_user.attempted_reallocations.where(claimed_currency: claimed_currency.id).where(active: true).reverse
      end

      paginated_attempted_reallocations = Kaminari.paginate_array(attempted_reallocations).page(params[:page]).per(params[:per_page])

      render json: paginated_attempted_reallocations, meta: pagination(paginated_attempted_reallocations, params[:per_page])
    else
      render json: { errors: "logged in user is inactive"}, status: 422
    end
  end

  def create
    if current_user.active == true
      attempted_reallocation = current_user.attempted_reallocations.build(attempted_reallocation_params)

      if attempted_reallocation.save
        render json: attempted_reallocation, status: 201, location: [:api, attempted_reallocation]
      else
        render json: { errors: attempted_reallocation.errors}, status: 422
      end
    else
      render json: { errors: "logged in user is inactive"}, status: 422
    end
  end

  private
    def attempted_reallocation_params
      params.require(:attempted_reallocation).permit(:claimed_currency_id)
    end
end
