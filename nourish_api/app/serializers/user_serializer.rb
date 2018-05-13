# app/models/serializers/user_serializer.rb
# User model serializer (non-admin / authenticated view)

class UserSerializer < ActiveModel::Serializer
  attributes :id, :nickname
end
