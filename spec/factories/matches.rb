# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :match do
    competition_id 1
    round 1
    milliseconds_elapsed 1
    player_id nil
    opponent_id nil
  end

  factory :knockout_match, :parent => :match  do
    association :competition, :factory => :knockout_competition
  end

end
