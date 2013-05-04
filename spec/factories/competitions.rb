# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :competition do
    starts_at "2013-04-22 12:11:14"
    ends_at "2013-04-22 12:11:14"
    name "MyString"
    description "MyText"
    tournament
    submission_mask 1
    game
    publish_at "2013-04-22 12:11:14"
  end

  factory :team_competition, :parent => :competition do
     association :game, :factory => :team_game
  end

  factory :knockout_competition, :parent => :competition do
    association :game, :factory => :knockout
  end


end
