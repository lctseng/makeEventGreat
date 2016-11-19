FactoryGirl.define do
  factory :event do
    title { "#{["Ruby", "Python", "C++", "Web"].sample} #{Faker::Pokemon.name} Meet up!" }
    location { ["北", "中", "南", "其他"].sample }
    start_date { Time.now }
    end_date { Time.now  + 5.days }
    description { Faker::Lorem.paragraphs.join("\n") }
    url { Faker::Internet.url }
    host { Faker::Pokemon.name }
    fee { rand(1000) }
    number_of_people { rand(100) }
    source_id { 1 }


    after(:build) do |event|
      (rand(3)+1).times do
        event.add_event_type(["Ruby","Python", "C++", "前端", "後端"].sample)
      end
    end

  end
end
