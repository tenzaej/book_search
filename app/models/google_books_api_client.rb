require 'net/http'

class GoogleBooksApiClient
  class ErrorResponse < StandardError; end
  class EmptyResponse < StandardError; end

  GOOGLE_BOOKS_BASE = 'https://www.googleapis.com/books/v1/volumes'

  def initialize(query)
    @query = query
  end

  def call()
    uri = self.class.format_uri(@query)
    json_response = Net::HTTP.get(uri)
    parsed_response = JSON.parse(json_response)
    if parsed_response["error"]
      error_message = "Google Books API returned a code #{parsed_response.dig('error', 'code')} with the message '#{parsed_response.dig('error', 'message')}'"
      raise ErrorResponse.new(error_message)
    elsif parsed_response["items"].nil?
      error_message = "Google Books API returned zero results for query '#{@query}'"
      raise EmptyResponse.new(error_message)
    else
      parsed_response
    end
  end

  def self.format_uri(query)
    query_string = "?q=#{query}"
    fields_specification = "&fields=items(volumeInfo(title,authors,publisher,previewLink,imageLinks(smallThumbnail)))"
    URI(GOOGLE_BOOKS_BASE + query_string + fields_specification)
  end
end
