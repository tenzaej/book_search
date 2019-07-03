class BooksController < ApplicationController
  def show
    @client = GoogleBooksClient.new(query_params)
    parsed_response = @client.call
    @books = BookCollection.new(parsed_response).assemble
  rescue StandardError => e
    Rails.logger.info e.message
    @books = []
  end

  private

  def query_params
    params.slice(:query, :page_number)
  end
end
