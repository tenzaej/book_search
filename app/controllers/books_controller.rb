class BooksController < ApplicationController
  def index
    @client = GoogleBooksClient.new
    @books = []
  end

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
    params.slice(:query, :page)
  end
end
