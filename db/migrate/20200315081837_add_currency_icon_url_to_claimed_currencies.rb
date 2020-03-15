class AddCurrencyIconUrlToClaimedCurrencies < ActiveRecord::Migration[5.1]
  def change
    add_column :claimed_currencies, :currency_icon_url, :string
  end
end
