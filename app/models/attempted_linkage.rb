class AttemptedLinkage < ApplicationRecord
  require 'net/http'
  require 'json'

  include RandomValue

  validates :currency_id_external_key, numericality: { only_integer: true, greater_than: 0 }

  validate :ensure_currency_exists_and_is_active
  validate :ensure_currency_is_not_claimed
  validate :ensure_user_has_no_active_attempted_linkage_for_currency

  belongs_to :user, inverse_of: :attempted_linkages
  belongs_to :claimed_currency, inverse_of: :attempted_linkages

  before_create :create_claimed_currency, unless: :claimed_currency_exists?
  before_create :create_deposit_confirmation_value

  private
    def create_claimed_currency
      ClaimedCurrency.create(currency_id_external_key: currency_id)     
    end

    def create_deposit_confirmation_value
      required_deposit_value = generate_random_value # the generate_random_value method is in the RandomValue module and generates a value between 1000 and 9999
      self.deposit_confirmation_value = required_deposit_value 
    end

    def ensure_currency_exists_and_is_active
      currency_id = self.currency_id_external_key.to_s
  
      response = Net::HTTP.get_response(URI('https://api.mycurrency.com/currencies/' + currency_id))

      json_str = JSON.parse(response.body)

      if response.code.to_i != 200
        errors.add(:currency_id, "does not exist on MyCurrency")
      elsif json_str["data"]["attributes"]["user-is-active"] == false
        errors.add(:issuer, "of currency is not active")
      else
        true
      end
    end

    def ensure_currency_is_not_claimed
      currency_id = self.currency_id_external_key.to_s

      # claimed_currency records where the currency_id_external_key field matches and the user_id column is set
      claimed_currencies_with_user_linked = ClaimedCurrency.where(currency_id_external_key: currency_id).where.not(user_id: [nil, ""]) 

      if claimed_currencies_with_user_linked.count > 0
        errors.add(:currency, "currency is already claimed so you cannot create an attempted linkage for it. To still claim it, please create an attempted reallocation to change the claimant from the user account that currently has a claim on the currency to your user account")
      else
        true
      end
    end

    def ensure_user_has_no_active_attempted_linkage_for_currency
      currency_id = self.currency_id_external_key.to_s

      claimed_currencies = ClaimedCurrency.where(currency_id_external_key: currency_id)

      if claimed_currencies.count > 0
        attempted_linkages = claimed_currencies.first.attempted_linkages

        active_attempted_linkages_by_user = attempted_linkages.where(user_id: self.user_id, active: true)

        if active_attempted_linkages_by_user > 0
          errors.add(:user, "already has an active attempted linkage to the specified currency")
        else
          true
        end 
      else
        true
      end
    end
    
    def claimed_currency_exists?
      currency_id = self.currency_id_external_key.to_s

      claimed_currencies = ClaimedCurrency.where(currency_id_external_key: currency_id)

      if claimed_currencies.count > 0
        true
      else
        false
      end
    end
end
