class BooksController < ApplicationController
  def show()
    @query = params['query']
    begin
      @books = GoogleBooksApiClient.new(@query).call
    rescue GoogleBooksApiClient::GoogleBooksApiError => e
      Rails.logger.error e.message
      render :index
    end
  end
end
