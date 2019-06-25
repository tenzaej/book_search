class BooksController < ApplicationController
  def show()
    @query = params['query'].strip
    begin
      parsed_response = GoogleBooksApiClient.new(@query).call
      @books = BookCollection.new(parsed_response).assemble
    rescue StandardError => e
      Rails.logger.info e.message
      render :index
    end
  end
end
