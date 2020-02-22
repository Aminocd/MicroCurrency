class ClaimedCurrency < ApplicationRecord
  belongs_to :user, inverse_of: :claimed_currencies
end
