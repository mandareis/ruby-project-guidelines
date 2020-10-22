require 'pry'

class CLI
  def initialize
    # Bet.destroy_all
    # Better.destroy_all
    # Game.destroy_all
    @better = nil
    @bet_amount = nil
  end

  def main_menu
    if @better == nil
     2.times {divider}
      puts "Welcome to Coin Collector!"
      puts ""
      puts "What is your name?"
      2.times {divider}
      name = get_user_response
      @better = create_better(name)
    end
    divider
    puts "Hi, #{@better.username.capitalize}!"
    # divider
    # puts "I am the Main Menu!"
    puts "You pick what to do next:"
    divider
    puts "1. Change username"
    puts "2. Check coin balance"
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
    else 
      error_message
      return self.main_menu
    end
  end

  def create_better(name)
    new_better = Better.create(username: name, points_balance: 10_000)
    new_better
  end

  def change_username
    puts "What would you like to change your name to?"
    new_name = get_user_response
    @better.username = new_name
    divider
    @better.save
    puts "#{new_name.capitalize}, what a kickass name!"
    divider
    sleep(1.5)
    return self.main_menu
  end

  def divider
    puts ""
    puts "<>" * 15
    puts ""
  end

  def check_points_balance
    puts "Your current coin-count is #{@better.points_balance} coins."
    sleep(1.5)
    puts "Enter anything to return to the main menu"
    if get_user_response
    return self.main_menu
    end 
  end

  def play_game(bet_amount)
    new_game = Game.create
    game_result = new_game.result
    new_game.outcome = game_result
    new_game.save
    divider 
    if bet_amount == nil
      if @better.points_balance == 1 
        puts "How much would you like to bet? You have 1 coin left"
        bet_amount = get_user_response.to_i
        if bet_amount > @better.points_balance
          over_bet 
        end
      elsif @better.points_balance == 0
        puts "You're out of coins! Oh no!"
        divider
        sleep(2)
        return self.main_menu
      else
        puts "How much would you like to bet? You have #{@better.points_balance} coins left"
        bet_amount = get_user_response.to_i
        if bet_amount > @better.points_balance
          over_bet 
        end
      end 
    elsif 
      if bet_amount > @better.points_balance
      over_bet
      end  
    end 
    new_bet = Bet.create(points_amount: bet_amount, better_id: @better.id, game_id: new_game.id)
    new_bet.points_amount = bet_amount
    make_bet
    divider
    puts "Heads or Tails?"
    user_guess = get_user_response
    divider
    puts "Flipping the coin!"
    divider
    sleep(1)
    if user_guess == game_result
      @better.points_balance += bet_amount
      @better.save
      sleep(1)
      puts "IT'S #{game_result.upcase}!! CONGRATULATIONS YOU WIN!!"
    else 
      @better.points_balance -= bet_amount
      @better.save
      sleep(1)
      puts "It's #{game_result.capitalize}. :( Better luck next time!"
    end
    sleep(1.5)
    divider
    double_or_nothing
  end 

  def bet_again
    puts "Would you like to place another bet?"
    puts "1. Why not?"
    puts "2. No, thanks."
    option_picked = get_user_response
    if option_picked == "1"
      play_game
    elsif option_picked =="2"
      return self.main_menu
    elsif option_picked == 'exit'
      exit
    else
      error_message
      bet_again
    end 
  end 

  def delete_better
    divider
    puts "Are you sure? You won't be able to play anymore"
    puts "1. Yes, I'm sure"
    puts "2. No, take me back to the menu"
    option_picked = get_user_response
    if option_picked == "1"
      divider
      puts "Goodbye #{@better.username.capitalize}! Don't go spending all those coins in one place!"
      divider
      Better.delete(@better.id)
    elsif option_picked == "2"
      return self.main_menu
    else 
      error_message 
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
      return self.main_menu
    end
  end

  # def make_bet
  #   new_bet = Bet.create(points_amount: @bet_amount, better_id: @better.id, game_id: new_game.id)
  #   new_bet.points_amount = @bet_amount
  # end 



  def over_bet
    puts ""
      puts "Exceeded limit on bet amount. Please bet within your limit."
      sleep(2)
      play_game
      divider
  end

  def error_message
    puts "Did not understand answer, please try again"
      divider 
      sleep(1)
  end


  def get_user_response
    gets.strip.downcase
  end
end 
