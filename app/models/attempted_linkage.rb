class AttemptedLinkage < ApplicationRecord
  belongs_to :user
  belongs_to :claimed_currency
end
