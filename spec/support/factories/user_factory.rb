# spec/support/factories/user_factory.rb

FactoryGirl.define do
  sequence :user_email do |index|
    "user.#{index}@example.com"
  end # sequence

  sequence :user_password do
    chars = [*'a'..'z', *'A'..'Z', *'0'..'9']
    count = 8 + rand(8)
    count.times.with_object('') do |_, str|
      str << chars[rand(chars.count)]
    end # times
  end

  factory :user do
    email { generate :user_email }

    password { generate :user_password }
    password_confirmation { password }

    factory :author do; end
  end # factory
end # define
