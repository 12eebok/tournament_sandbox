# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tournament do
    name "MyString"
    instructions "MyText"
    starts_at "2010-04-19 14:17:21"
    ends_at "2015-04-19 14:17:21"
  end
end
