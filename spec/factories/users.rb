FactoryGirl.define do
  factory :user do
    name {"huynguyen"}
    email {Faker::Internet.email}
    phone {"0935732121"}
    password {"091214"}
    password_confirmation {"091214"}
  end
end
