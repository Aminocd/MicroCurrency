class Api::V1::AuthorizedUserSerializer < Api::V1::UserSerializer
  attributes :email, :active
end
