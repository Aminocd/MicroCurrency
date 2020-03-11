class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def self.show_all(collection_proxy)
    collection_proxy.find_each do |r|
      puts "\n"
      puts r.inspect
      puts
    end
  end

  def self.microcurrency_deposit_user_id
    MICROCURRENCY_DEPOSIT_USER_ID
  end

  def self.microcurrency_credit_currency_id
    MICROCURRENCY_CREDIT_CURRENCY_ID
  end

  def self.microcurrency_store_id
    MICROCURRENCY_STORE_ID
  end

  def self.currency_product_category_id
    CURRENCY_PRODUCT_CATEGORY_ID
  end

  private
    MICROCURRENCY_DEPOSIT_USER_ID = 165

    MICROCURRENCY_CREDIT_CURRENCY_ID = 94
    
    MICROCURRENCY_STORE_ID = 60

    CURRENCY_PRODUCT_CATEGORY_ID = 83
end
