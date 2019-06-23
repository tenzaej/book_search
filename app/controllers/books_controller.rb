require 'net/http'

class BooksController < ApplicationController
  def show()
    @query = params['query']
    uri = URI( "https://www.googleapis.com/books/v1/volumes?q=#{@query}")
    json_response = Net::HTTP.get(uri)
    @books = JSON.parse(json_response)
  end
end
