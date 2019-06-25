require 'net/http'

class GoogleBooksApiClient
  class GoogleBooksApiError < StandardError; end

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
      raise GoogleBooksApiError.new(error_message)
    end
    parsed_response
  end

  def self.format_uri(query)
    query_string = "?q=#{query}"
    URI(GOOGLE_BOOKS_BASE + query_string)
  end
end
