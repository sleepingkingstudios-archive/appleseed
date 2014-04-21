# spec/support/factories/tagging_factory.rb

FactoryGirl.define do
  factory :tagging do
    sequence(:name) { |index| "Tagging #{index}" }
  end # factory
end # define
