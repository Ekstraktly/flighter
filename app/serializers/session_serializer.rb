class SessionSerializer < ActiveModel::Serializer
  attribute :token
  attribute :user
end
