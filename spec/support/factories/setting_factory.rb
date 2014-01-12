# spec/support/factories/user_factory.rb

FactoryGirl.define do
  factory :setting do
    sequence(:name) { |index| "Setting #{index}" }

    type 'String'
  end # factory
end # define
