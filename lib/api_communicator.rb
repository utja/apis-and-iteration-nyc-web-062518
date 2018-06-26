require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)
  #make the web request
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)

  while character_hash
    film_urls = character_hash["results"].find do |hash|
      hash["name"].downcase == character
    end

    if film_urls
      film_data = film_urls["films"].map do |film|
        JSON.parse(RestClient.get(film))
      end
    end
    ## a ? b : c (if a then b, else c)
    character_hash = character_hash["next"] ? JSON.parse(RestClient.get(character_hash["next"])) : nil
  end
  film_data
end

#   #MY SOLUTION
#   ######gives array results of all character hashes
#   character_information = character_hash["results"]
#   binding.pry
#   ######this gives array individual hash result for the character
#   character_films_array = character_information.collect do |result|
#     if result["name"].downcase == character
#       result["films"]
#     end
#   end.compact
#
#   character_films = character_films_array.compact.flatten
#
#   films_hash = character_films.collect do |movie_url|
#     all_movies = RestClient.get(movie_url)
#     movie_hash = JSON.parse(all_movies)
#   end
#
#   movies_array = []
#   films_hash.each do |hash|
#     hash.each do |key, value|
#       if key == "title"
#         movies_array << value
#       end
#     end
#   end
#   movies_array
# end
  # iterate over the character hash to find the collection of `films` for the given
  #   `character`
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.


def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  films_hash.each.with_index(1) do |data, index|
    puts "#{index} " + data["title"]
  end
end


def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
