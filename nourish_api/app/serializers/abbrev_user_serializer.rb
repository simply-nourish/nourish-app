# AbbrevUserSerializer: abbreviated user data
# app/serializers/abbrev_user_serializer.rb

class AbbrevUserSerializer < ActiveModel::Serializer
  attributes :nickname
end