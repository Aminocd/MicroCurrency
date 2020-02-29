class ClaimedCurrency < ApplicationRecord
  require 'net/http'
  require 'json'

  belongs_to :user, inverse_of: :claimed_currencies, optional: true
  has_many :attempted_linkages, inverse_of: :claimed_currency

  before_create :create_product_on_mycurrency

  private
    def create_product_on_mycurrency
      currency_id = self.currency_id_external_key.to_s

      # first return the currency details from MyCurrency
      response = Net::HTTP.get_response(URI('https://api.mycurrency.com/currencies/' + currency_id))
      
      # turn response into json
      json_response = JSON.parse(response.body)

      # get the currency name from the json representation of currency details
      currency_name = json_response["data"]["attributes"]["name"] 

      # turn create product API endpoint URL into a URI object
      uri = URI("https://api.mycurrency.com/users/#{A.microcurrency_deposit_user_id}/issuer/currencies/#{A.microcurrency_credit_currency_id}/stores/#{A.microcurrency_store_id}/products")

      # populate params variable that will be posted to the MyCurrency Create Store API endpoint
      params = {"product": {'sub_category_id': "#{A.currency_product_category_id}", 'name':"Credit for #{currency_name}", 'description': "used by MicroCurrency companion app for internal operations to issue MyCurrency vouchers", "active": "true", "price_cents": "100"}}
      
      # populate header variable that will be posted alongside params variable
      headers = {
        'Authorization'=>"Bearer #{ENV['AUTHORIZATION_TOKEN']}",
        'Content-Type' =>'application/json',
        'Accept'=>'application/json'
      }

      # create new HTTP object
      http = Net::HTTP.new(uri.host, uri.port)

      # post the variables and headers to create product and get back the response.
      response = http.post(uri.path, params.to_json, headers)

      # see the response
      puts response.body
    end
end
