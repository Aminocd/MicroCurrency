class Api::V1::AttemptedReallocationSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :claimed_currency_id, :created_at, :updated_at
end
