class AttemptedReallocation < ApplicationRecord
  require 'net/http'
  require 'json'

  validate :ensure_claimed_currency_exists_and_is_claimed
  validate :ensure_user_has_no_active_attempted_reallocation_for_currency

  belongs_to :user, inverse_of: :attempted_reallocations
  belongs_to :claimed_currency, inverse_of: :attempted_reallocations

  def self.deactivate_attempted_reallocations_above_age_threshold
    cutoff = Time.now - A.cutoff_minutes.minutes # the cutoff time is 15 minutes before program runtime 
    wrong_cutoff = Time.now - 1.year # use a far back cutoff or testing purposes TODO: remove old date assignment on this line and the one below it
    cutoff = wrong_cutoff # will comment out after testing
    AttemptedReallocation.where(active: true).where("created_at < ?", cutoff).update_all(active: false) # deactivate all attempted reallocaitons older than 15 minutes ago and that are true
  end

  private
    def ensure_claimed_currency_exists_and_is_claimed
      claimed_currency = ClaimedCurrency.find(self.claimed_currency_id)

      if claimed_currency.nil?
        errors.add(:claimed_currency, "doesn't exist so try an attempted linkage instead")
      elsif claimed_currency.user.nil?
        errors.add(:claimed_currency, "doesn't have a user that's claiming it so try an attempted linkage instead")
      else
        true
      end
    end

    def ensure_user_has_no_active_attempted_reallocation_for_currency
      claimed_currency = ClaimedCurrency.find(self.claimed_currency_id)

      unless claimed_currency.nil?
        attempted_reallocations = claimed_currency.attempted_reallocations

        active_attempted_reallocations_by_user = attempted_reallocations.where(user_id: self.user_id, active: true)

        if active_attempted_reallocations_by_user.count > 0
          errors.add(:user, "already has an active attempted reallocation to the specified currency")
        else
          true
        end 
      end
    end
end
