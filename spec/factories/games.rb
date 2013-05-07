# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    name "Custom Game"
    format "Custom"
    required_fields "player_id,opponent_id,winner_id"
    team_based false
    min_entries 1
    max_entries 1
  end

  factory :team_game, :parent => :game do
    required_fields "player_id,opponent_id,winner_id"
    team_based true
  end

  factory :knockout, :parent => :game do
    format "Elimination"
  end

  factory :round_robin, :parent => :game do
    format "Round Robin"
  end

end
