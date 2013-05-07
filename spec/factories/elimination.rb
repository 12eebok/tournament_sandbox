FactoryGirl.define do

  factory :elimination do
    association :competition, :factory => :knockout_competition
    round 1
    milliseconds_elapsed 1
    player_id nil
    opponent_id nil
  end

end
