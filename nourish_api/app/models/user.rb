class User < ApplicationRecord
  # encrypt password
  has_secure_password

  # associations, if any

  # validates values exist
  validates_presence_of :first_name, :last_name, :email, :password_digest, :default_servings
end
