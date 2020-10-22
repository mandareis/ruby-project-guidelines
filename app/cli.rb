require 'pry'

class CLI
  def initialize
    # Bet.destroy_all
    # Better.destroy_all
    # Game.destroy_all
    @better = nil
  end

  def main_menu
    if @better == nil
      divider
      puts "Welcome to Coinz!"
      puts ""
      puts "What is your name?"
      name = get_user_response
      @better = create_better(name)
    end
    divider
    puts "Hi, #{@better.username}!"
    divider
    puts "I am the Main Menu!"
    puts "You pick what to do next:"
    divider
    puts "1. Change username"
    puts "2. Check point balance"
    puts "3. Play a game"
    puts "4. Checkout"
    puts "5. Quit"
    divider
    option_picked = get_user_response
    if option_picked == "1"
      change_username
    elsif option_picked == "2"
      check_points_balance
    elsif option_picked == "3"
      play_game
    elsif option_picked == "4"
      delete_better
    elsif option_picked == "5"
      divider 
      puts "I hope you had fun! We'll miss you"
      divider
      exit
    end
  end

  def create_better(name)
    new_better = Better.create(username: name, points_balance: 10_000)
    #new_better.save
    new_better
  end

  def change_username
    puts "What would you like to change your name to?"
    new_name = get_user_response
    @better.username = new_name
    divider
    @better.save
    puts "#{new_name}, what a kickass name!"
    divider
    sleep(2.5)
    return self.main_menu
  end

  def divider
    puts ""
    puts "<>" * 15
    puts ""
  end

  #need to create the method that updates this once user places a bet ?
  def check_points_balance
    puts "Your current balance is #{@better.points_balance}."
    # The transition back to the main menu is too fast!
    # Wait for a sec...
    sleep(2.5)
    return self.main_menu
  end

  # def play_game
  #   new_game = Game.create
  #   game_result = new_game.result
  #   new_game.outcome = game_result
  #   new_game.save
  #   divider
  #   puts "How much would you like to bet? You have #{@better.points_balance} points left"
  #   bet_amount = get_user_response.to_i
  #   new_bet = Bet.create(points_amount: bet_amount, better_id: @better.id, game_id: new_game.id)
  #   new_bet.points_amount = bet_amount
  #   divider
  #   puts "Heads or Tails?"
  #   user_guess = get_user_response
  #   divider
  #   puts "Flipping the coin!"
  #   divider
  #   sleep(2)
  #   if user_guess == game_result
  #     @better.points_balance += bet_amount
  #     @better.save
  #     sleep(1)
  #     divider
  #     puts "CONGRATULATIONS YOU WIN!!"
  #   else 
  #     @better.points_balance -= bet_amount
  #     @better.save
  #     sleep(1)
  #     puts "You have guessed unwisely! try again, nerd"
  #   end
  #   sleep(3)
  #   divider
  #   bet_again
  # end 

  def play_game(bet_amount=nil)
    new_game = Game.create
    game_result = new_game.result
    new_game.outcome = game_result
    new_game.save
    divider
    if bet_amount == nil
      puts "How much would you like to bet? You have #{@better.points_balance} points left"
      bet_amount = get_user_response.to_i
    end 
    new_bet = Bet.create(points_amount: bet_amount, better_id: @better.id, game_id: new_game.id)
    new_bet.points_amount = bet_amount
    divider
    puts "Heads or Tails?"
    user_guess = get_user_response
    divider
    puts "Flipping the coin!"
    divider
    sleep(2)
    if user_guess == game_result
      @better.points_balance += bet_amount
      @better.save
      sleep(1)
      divider
      puts "CONGRATULATIONS YOU WIN!!"
    else 
      @better.points_balance -= bet_amount
      @better.save
      sleep(1)
      puts "You have guessed unwisely! try again, nerd"
    end
    sleep(3)
    divider
    double_or_nothing
  end 

  def bet_again
    puts "Would you like to place another bet?"
    puts "Y/N"
    option_picked = get_user_response
    if option_picked == "y"
      play_game
    elsif option_picked =="n"
      return self.main_menu
    elsif option_picked == 'exit'
      exit
    else
      puts "Did not understand answer, please type Y or N"
      bet_again
    end 
  end 

  def delete_better
    divider
    puts "Are you sure? You won't be able to play anymore"
    puts "Y/N"
    option_picked = get_user_response
    if option_picked == "y"
      divider
      puts "Goodbye #{@better.username.capitalize}! Don't go spending all those points in one place!"
      divider
      Better.delete(@better.id)
    elsif option_picked == "n"
      return self.main_menu
    else 
      puts "Did not understand answer, please try again"
      divider 
      sleep(1)
      delete_better
    end
  end 

  def double_or_nothing
    puts "Double or nothing?"
    puts "1. Hell yeah"
    puts "2. Naw I'm good"
    option_picked = get_user_response
    if option_picked == "1"
      play_game((Bet.last.points_amount) * 2)
    elsif option_picked == "2"
      bet_again
    end
  end



  def get_user_response
    gets.strip.downcase
  end
end
