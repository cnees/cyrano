class HomeController < ApplicationController
  require "net/http"
  require "uri"
  require "json"
  require "set"
  require "dinosaurus"

  def http_get_json(uri_string)
    uri = URI(URI.encode(uri_string))
    JSON.parse(Net::HTTP.get(uri))
  end

  def get_synonyms(word)
    synonyms = Dinosaurus.synonyms_of(word).push(word)
    #related_words = http_get_json("https://api.datamuse.com/words?ml=#{word}")
    #related_words.each do |related_word|
    #  synonyms.push(related_word["word"])
    #end
  end

  # Format: {{"word":"rhyme1","score":#,"numSyllables":#},
  #          {"word":"rhyme2","score":#,"numSyllables":#}...}
  def get_rhymes(word)
    # API courtesy of Datamuse
    rhymes = http_get_json("https://api.datamuse.com/words?rel_rhy=#{word}")
  end

  def index
    if(params.has_key?(:word1) && params.has_key?(:word2))
      synonyms1 = get_synonyms(params[:word1])
      synonyms2 = get_synonyms(params[:word2])

      synonym_set = Set.new(synonyms1)
      results = Array.new

      synonyms2.each do |syn|
        get_rhymes(syn).each do |rhyme|
          if(synonym_set.include?(rhyme))
            results.append([syn, rhyme])
          end
        end
      end

      render json: results
    end
  end
end

