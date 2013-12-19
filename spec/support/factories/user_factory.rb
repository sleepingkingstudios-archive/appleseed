# spec/support/factories/user_factory.rb

FactoryGirl.define do
  sequence :user_email do |index|
    "user.#{index}@example.com"
  end # sequence

  factory :user do
    email { generate :user_email }
  end # factory
end # define
