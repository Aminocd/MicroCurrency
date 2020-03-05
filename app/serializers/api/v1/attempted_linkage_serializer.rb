class Api::V1::AttemptedLinkageSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :claimed_currency_id, :deposit_confirmation_value, :created_at, :updated_at, :currency_id_external_key
end
