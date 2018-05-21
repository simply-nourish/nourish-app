class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  # custom profile additions and validate password existence

  # validates values exist
  validates_presence_of :first_name, :last_name, :email, 
  :encrypted_password, :default_servings

  # associations
  # if a user is deleted, also delete associated recipes
  has_many :recipes, dependent: :destroy

  # if a user is deleted, also delete associated meal_plans
  has_many :meal_plans, dependent: :destroy

  # user nicknames must be unique
  validates_uniqueness_of :nickname

end
