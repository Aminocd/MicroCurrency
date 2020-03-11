class ClaimedCurrency < ApplicationRecord
  require 'net/http'
  require 'json'

  belongs_to :user, inverse_of: :claimed_currencies, optional: true
  has_many :attempted_linkages, inverse_of: :claimed_currency

  before_create :create_product_on_mycurrency

  def check_transactions_for_confirmation_value(user_id)
    # get attempted_linkages linked to claimed_currency which were created by the user and are active
    attempted_linkages = self.attempted_linkages.where(user_id: user_id, active: true) 

    # only look at the last attempted_linkage in case the validation preventing multiple active attempted_linkages from a specific user for a claimed_currency being created somehow failed and multiple attempted_linkages exist that have these properties
    last_attempted_linkage = attempted_linkages.last

    ## retrieve the private currency holding of the MicroCurrency_Deposit account that holds the specified currency
    # create URI object
    uri = URI("https://api.mycurrency.com/authorized_currencies/#{self.currency_id_external_key.to_s}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.start
    request = Net::HTTP::Get.new(uri.request_uri, get_headers_hash)
    response = http.request(request)

    # Rails.logger.info "the response code is #{response.code}"
    # Rails.logger.info "the response is #{response.inspect}"
    # Rails.logger.info "the response body is #{response.body}"
    
    if (response.code.to_i == 200 && (last_attempted_linkage != nil))
      json_str = JSON.parse(response.body)
      private_currency_holding_id = json_str["data"]["attributes"]["private-currency-holding-id"]
      
      unless private_currency_holding_id.nil?
  #      Rails.logger.info "\n\ncode is 200\n\n"

        ## authenticate attempted_linkage by checking if a transfer or issuance was received from the issuer of the currency associated with the private currency holding that was created after the attempted linkage's creation date and that matches the attempted linkage's confirmation value
        # get the deposit confirmation value from attempted_linkage
        amount = last_attempted_linkage.deposit_confirmation_value

        # get the created_at unit time of the attempted_linkage
        start_time = last_attempted_linkage.created_at.to_i 

        uri = URI("https://api.mycurrency.com/users/#{A.microcurrency_deposit_user_id}/authorized_private_currency_holdings/#{private_currency_holding_id}/pr_h_authentication_transaction?amount=#{amount}&start_time=#{start_time}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.start
        request = Net::HTTP::Get.new(uri.request_uri, get_headers_hash)
        response = http.request(request)
        json_str = JSON.parse(response.body)
        transaction_authentication_status = json_str["data"]["attributes"]["transaction-authentication-status"]

        if transaction_authentication_status
          if self.user.nil?
            self.update_column(:user_id, user_id)
            attempted_linkages = self.attempted_linkages.where(user_id: user_id, active: true).update_all(active: false)
          end
        end
  #      Rails.logger.info "the second response code is #{response.code}"
  #      Rails.logger.info "the second response is #{response.inspect}"
  #      Rails.logger.info "the second response body is #{response.body}"
  #   else
  #      Rails.logger.info "\n\ncode is not 200\n\n"
      end
    end
  end

  def get_currency_attributes
    response = Net::HTTP.get_response(URI('https://api.mycurrency.com/currencies/' + self.currency_id_external_key.to_s))
    if response.code.to_i == 200
      json_str = JSON.parse(response.body)
      json_str["data"]["attributes"]
    else
      nil
    end

  end
  
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
      params = {"product": {'sub_category_id': "#{A.currency_product_category_id}", 'product_name':"Credit for #{currency_name}", 'product_description': "used by MicroCurrency companion app for internal operations to issue MyCurrency vouchers", "active": "true", "price_cents": "100"}}
      
      # create new HTTP object
      http = Net::HTTP.new(uri.host, uri.port)

      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      # post the variables and headers to create product and get back the response.
      response = http.post(uri.path, params.to_json, get_headers_hash)      
      # for testing
      Rails.logger.info "\n\nProduct create Inspect #{response.inspect}\n\n"
      Rails.logger.info "\n\nProduct create The body: #{response.body}\n\n"
      Rails.logger.info "\n\nProduct create The code: #{response.code}\n\n"
      json_response = JSON.parse(response.body)
      product_id = json_response["data"]["id"]

      if response.code.to_i != 201
	      throw :abort
        false
      else
        self.product_id_external_key = product_id
      end
    end
    
    def get_headers_hash
      # populate header variable that will be sent with the request to the MyCurrency server
      headers = {
        'Authorization'=>"Bearer #{ENV['AUTHORIZATION_TOKEN']}",
        'Content-Type' =>'application/json',
        'Accept'=>'application/json'
      }
    end
end
