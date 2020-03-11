class Api::V1::ClaimedCurrencySerializer < ActiveModel::Serializer
  attributes :id, :user_id, :created_at, :updated_at, :currency_id_external_key, :product_id_external_key

  attribute :currency_name ## method
  attribute :currency_icon_url ## method
  attribute :status_of_claimed_currency ## method

  def currency_name
    unless @instance_options.nil?
      @instance_options[:currency_name]
    else
      nil
    end
  end

  def currency_icon_url
    unless @instance_options.nil?
      @instance_options[:currency_icon_url]
    else
      nil
    end
  end

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
