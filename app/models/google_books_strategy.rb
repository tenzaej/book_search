class GoogleBooksStrategy
  class ErrorResponse < StandardError; end

  BASE_URI = 'https://www.googleapis.com/books/v1/volumes'
  FIELDS_SPECIFICATION = '&fields=items(volumeInfo(title,authors,publisher,infoLink,imageLinks(smallThumbnail)))'

  attr_reader :query, :page

  def initialize(options)
    @query = options[:query]
    @page = format_page(options[:page])
  end

  def call(http_client)
    parsed_response = JSON.parse(http_client.get)
    if parsed_response['error']
      error_message = "Google Books API returned a code #{parsed_response.dig('error', 'code')} with the message '#{parsed_response.dig('error', 'message')}'"
      raise ErrorResponse, error_message
    end
    parsed_response
  end

  def uri
    BASE_URI +
      query_param +
      FIELDS_SPECIFICATION +
      page_param
  end

  private

  def query_param
    "?q=#{query}"
  end

  def page_param
    "&startIndex=#{(page - 1) * 10}"
  end

  def format_page(page)
    [page.to_i.floor, 1].max
  end
end
