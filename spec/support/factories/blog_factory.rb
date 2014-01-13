# spec/support/factories/blog_factory.rb

FactoryGirl.define do
  factory :blog do
    sequence(:title) { |index| "Blog #{index}" }
  end # factory
end # define
