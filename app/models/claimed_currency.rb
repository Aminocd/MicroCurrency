class ClaimedCurrency < ApplicationRecord
  belongs_to :user, inverse_of: :claimed_currencies, optional: true
  has_many :attempted_linages, inverse_of: :claimed_currency
end
