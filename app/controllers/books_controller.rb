class BooksController < ApplicationController
  def show
    @page = query_params[:page].to_i
    @query = query_params[:query]
    @books = Rails.cache.fetch([@query, @page]) do
      Rails.logger.info "Making an API call for '#{@query}', page #{@page}"
      parsed_response = HttpClient.new(GoogleBooksStrategy.new(query_params)).call
      BookCollection.new(parsed_response).assemble
    end
    render partial: '/books/show', locals: {books: @books}
  rescue StandardError => e
    Rails.logger.info e.message
    @books = []
  end

  private

  def query_params
    params.slice(:query, :page)
  end
end
