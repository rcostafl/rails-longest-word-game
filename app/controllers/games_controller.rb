require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    alphabet = ('a'..'z').to_a
    grid_size = 9

    grid_size.times do
      @letters.push(alphabet[rand(26)])
    end

    session[:score] = 0 if session[:score].nil?
  end

  def score
    @message = ''
    word_is_valid = true

    word        = params[:word]
    letters     = params[:letters]
    time_lapse  = Time.now.to_i - params[:start_time].to_i

    hash_word = generate_hash_count_letter_from_array(word.split(''))
    hash_letters = generate_hash_count_letter_from_array(letters.split(''))

    # Check if the word use letters from the grid
    unless word_use_letters?(hash_word, hash_letters)
      word_is_valid = false
      @message = "Sorry, but #{word} can't be built out of #{letters.split('').join(', ')}"
    else
      unless typed_string_is_word?(word)
        word_is_valid = false
        @message = "Sorry, but #{word.upcase} does not seem to be a valid English word..."
      else
        @message = "Congratulations! #{word.upcase} is a valid English word!"
      end
    end

    session[:score] += calculate_score(word, word_is_valid, time_lapse)
    @score = session[:score]
  end

  def generate_hash_count_letter_from_array(array)
    hash_letters_count = {}
    array.uniq.each do |letter|
      hash_letters_count[letter.to_sym] = array.count(letter)
    end

    hash_letters_count
  end

  def word_use_letters?(hash_word, hash_letters)
    use_letters = true

    hash_word.each_key do |key|
      use_letters = false if hash_letters[key].nil? || hash_word[key] > hash_letters[key]
    end

    use_letters
  end

  def typed_string_is_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    word['found']
  end

  def calculate_score(word, word_is_valid, time_lapse)
    score = 0
    if word_is_valid
      score += (word.length / 9.0) * 50
      score += ((30 - time_lapse) / 30.0) * 50
    end
    score
  end
end
