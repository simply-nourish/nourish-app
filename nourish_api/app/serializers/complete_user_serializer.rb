# app/models/serializers/complete_user_serializer.rb
# User model serializer (admin / authenticated view)

class CompleteUserSerializer < AbbrevUserSerializer
  attributes :first_name, :last_name, :email, :default_servings, :image, :nickname
end
