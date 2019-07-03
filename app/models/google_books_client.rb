require 'net/http'

class GoogleBooksClient
  class ErrorResponse < StandardError; end

  GOOGLE_BOOKS_BASE = 'https://www.googleapis.com/books/v1/volumes'
  FIELDS_SPECIFICATION = '&fields=items(volumeInfo(title,authors,publisher,infoLink,imageLinks(smallThumbnail)))'

  attr_reader :query, :page_number

  def initialize(options = {})
    @query = options[:query]
    @page_number = format_page_number(options[:page_number])
  end

  def call
    json_response = Net::HTTP.get(formatted_uri)
    parsed_response = JSON.parse(json_response)
    if parsed_response['error']
      error_message = "Google Books API returned a code #{parsed_response.dig('error', 'code')} with the message '#{parsed_response.dig('error', 'message')}'"
      raise ErrorResponse, error_message
    else
      parsed_response
    end
  end

  private

  def formatted_uri
    full_query =
      GOOGLE_BOOKS_BASE +
      query_string_parameter +
      FIELDS_SPECIFICATION +
      start_index_parameter

    URI(full_query)
  end

  def format_query(query)
    query.try(:strip)
  end

  def format_page_number(page_number)
    [page_number.to_i.floor, 1].max
  end

  def query_string_parameter
    "?q=#{@query}"
  end

  def start_index_parameter
    "&startIndex=#{(@page_number - 1) * 10}"
  end
end
