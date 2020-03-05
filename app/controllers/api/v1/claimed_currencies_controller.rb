class Api::V1::ClaimedCurrenciesController < APIController
	before_action only: [:show, :index] do
		authenticate_user!
	end

  def show
    if current_user.active
      claimed_currency = ClaimedCurrency.find(params[:id])

      if claimed_currency.nil?
        claimed_currency.check_transactions_for_confirmation_value(current_user.id)
      end

      currency_attributes = claimed_currency.get_currency_attributes

      render json: claimed_currency, currency_name: currency_attributes["name"], currency_icon_url: currency_attributes["get-icon-url"]
    else
      render json: { errors: "can't view claimed currency as logged in user is inactive"}, status: 403
    end
  end

  def index
    if current_user.active
       
    else
      render json: { errors: "can't view claimed currencies as logged in user is inactive"}, status: 403
    end
  end

  private
end
