require 'nokogiri'
require 'open-uri'

class GamesController < ApplicationController
# new action will be used to generate a new random grid and form
# form will be submitted (POST) to the score action

  def new
    @letters = []
    grid = ("A".."Z").to_a
    10.times do
      @letters << grid.shuffle.sample
    end
    @letters
  end

  def call_api
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    file = URI.open(url).read
    @result = JSON.parse(file)
    @result["found"]
    end

  def score
    @results = call_api
    @word = @word.upcase.chars
    grid = params[:grid].split
    @message = "try again"
    if @results
      if @word.all? {|e| grid.include?(e) }
        @score = @result["length"]
        @message = "valid word, well done"
      else
        @score = 0
        @message = "invalid word, try again"
      end
    else
      @message = "not an english word"
      @score = 0
    end
  end


end
