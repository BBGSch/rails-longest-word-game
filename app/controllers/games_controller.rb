require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    @alphabet = ("a".."z").to_a
    @letters << @alphabet.sample(10)
    @letters.flatten!

  end


  def read_json(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    dictionary_feedback_json = open(url).read
    hash_answer = JSON.parse(dictionary_feedback_json)
    hash_answer["found"]
  end


  def run_game(attempt, grid)
    result = Hash.new(0)
    if read_json(attempt) && grid_check_feedback(attempt, grid)
      result[:score] = attempt.length
      result[:message] = "well done"
    elsif read_json(attempt) != true
      result[:score] = 0
      result[:message] = "not an english word"
    elsif grid_check_feedback(attempt, grid) != true
      result[:score] = 0
      result[:message] = "not in the grid"
    end
    result
  end

  def score
    @grid = params[:letters].split("")
    @result = run_game(params[:answer], @grid)
  end

  def grid_check_feedback(attempt, grid)
    attempt_array = attempt.downcase.split("")

    attempt_hash = Hash.new(0)
    attempt_array.each { |letter| attempt_hash[letter] += 1 }

    grid_hash = Hash.new(0)
    grid.each { |letter| grid_hash[letter] += 1 }

    attempt_hash.all? { |key, value| value <= grid_hash[key] }
  end

end
