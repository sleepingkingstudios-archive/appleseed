# spec/support/factories/blog_factory.rb

FactoryGirl.define do
  factory :blog_post do
    author

    blog

    sequence(:title) { |index| "Blog Post #{index}" }

    content_type 'plain'
  end # factory
end # define
