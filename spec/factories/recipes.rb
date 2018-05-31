FactoryBot.define do
  factory :recipe do
    user_id nil
    title { Faker::Lorem.unique.sentence}
    summary { Faker::Lorem.sentence }
    source { Faker:: Internet.domain_name }
    instructions { Faker::Lorem.paragraph }
    servings { Faker::Number.between(1,32) }
  end
end
