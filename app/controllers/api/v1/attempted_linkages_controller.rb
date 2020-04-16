class Api::V1::AttemptedLinkagesController < APIController
	before_action only: [:show, :index, :create] do
		authenticate_user!
	end

  def show
    attempted_linkage = current_user.attempted_linkages.find(params[:id])

    render json: attempted_linkage
  end

  def index
    if current_user.active == true
      # all active attempted_linkages of the user
      if params[:claimed_currency_id].nil?
        attempted_linkages = current_user.attempted_linkages.where(active: true).reverse
      else
      # all active attempted_linkages of the user for the claimed_currency specified by the claimed_currency_id param
        claimed_currency = ClaimedCurrency.find(params[:claimed_currency_id])
        attempted_linkages = current_user.attempted_linkages.where(claimed_currency: claimed_currency.id).where(active: true).reverse
      end

      paginated_attempted_linkages = Kaminari.paginate_array(attempted_linkages).page(params[:page]).per(params[:per_page])

      render json: paginated_attempted_linkages, meta: pagination(paginated_attempted_linkages, params[:per_page])
    else
      render json: { errors: "logged in user is inactive"}, status: 422
    end
  end

  def create
    if current_user.active == true
      attempted_linkage = current_user.attempted_linkages.build(attempted_linkage_params)

      if attempted_linkage.save
        render json: attempted_linkage, status: 201, location: [:api, attempted_linkage]
      else
        render json: { errors: attempted_linkage.errors}, status: 422
      end
    else
      render json: { errors: "logged in user is inactive" }, status: 422
    end
  end

  private
    def attempted_linkage_params
      params.require(:attempted_linkage).permit(:currency_id_external_key)
    end
end
