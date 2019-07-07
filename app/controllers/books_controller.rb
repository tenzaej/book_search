class BooksController < ApplicationController
  def show
    @page = query_params[:page].to_i
    @query = query_params[:query]
    parsed_response = HttpClient.new(GoogleBooksStrategy.new(query_params)).call
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
