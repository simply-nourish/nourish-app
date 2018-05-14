FactoryBot.define do
  factory :recipe do
    user_id nil
    title { Faker::Lorem.sentence}
    summary { Faker::Lorem.sentence }
    source { Faker:: Internet.domain_name }
    instructions { Faker::Lorem.paragraph }
  end
end
