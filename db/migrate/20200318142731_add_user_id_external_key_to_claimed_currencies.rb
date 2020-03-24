class AddUserIdExternalKeyToClaimedCurrencies < ActiveRecord::Migration[5.1]
  def change
    add_column :claimed_currencies, :user_id_external_key, :integer
  end
end
