require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @random_letters = 10.times.map { ('a'..'z').to_a.sample }
  end

  def score
    @grid = params[:grid]
    @attempt = params[:answer].downcase
    @result = if included?(@attempt, @grid)
                english_word?(@attempt) ? 'well done' : 'not an english word'
              else
                'not in the grid'
              end
  end

  private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
