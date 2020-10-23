class Better < ActiveRecord::Base

  has_many :bets
  has_many :games, through: :bets

end
