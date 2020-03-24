class Api::V1::ClaimedCurrencySerializer < ActiveModel::Serializer
  attributes :id, :user_id, :created_at, :updated_at, :currency_id_external_key, :product_id_external_key, :currency_name, :currency_icon_url, :user_id_external_key

  attribute :status_of_claimed_currency ## method

  def status_of_claimed_currency
    if object.user.nil?
      "unclaimed"
    elsif object.user.id == @instance_options[:logged_in_user_id]
      "claimed_by_you"
    else
      "claimed_by_another_user"
    end
  end
end
