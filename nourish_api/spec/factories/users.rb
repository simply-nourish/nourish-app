FactoryBot.define do
  factory :user do
    nickname { Faker::VentureBros::character }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker:: Internet.email }
    password { Faker::Internet.password }
    default_servings { Faker::Number.number(1) }
  end
end