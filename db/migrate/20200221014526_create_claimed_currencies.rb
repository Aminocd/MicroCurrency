class CreateClaimedCurrencies < ActiveRecord::Migration[5.1]
  def change
    create_table :claimed_currencies do |t|
      t.references :user, foreign_key: true      
      t.integer :currency_id_external_key
      t.timestamps
    end
  end
end
