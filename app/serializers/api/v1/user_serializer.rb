class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :created_at, :updated_at, :username
end
