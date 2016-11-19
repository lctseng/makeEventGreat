FactoryGirl.define do
  factory :event do
    title { "#{["Ruby", "Python", "C++", "Web"].sample} #{Faker::Pokemon.name} Meet up!" }
    location { Faker::Pokemon.location }
    start_date { Time.now }
    end_date { Time.now  + 5.days }
    description { "#{["Ruby", "Python", "C++", "Web"].sample} Meet up!" + Faker::Lorem.paragraphs.join("\n") }
    url { Faker::Internet.url }
    host { Faker::Pokemon.name }
    fee { rand(1000) }
    number_of_people { rand(100) }
  end
end
