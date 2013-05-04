# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :registration do
    registerable_id nil
    registerable_type nil
    entry_id nil
    place nil
    score nil
    disqualified false
    disqualification_reason nil
    competition
  end

  factory :team_registration, :parent => :registration do
    association :competition, :factory => :team_competition
  end
end
