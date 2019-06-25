class BooksController < ApplicationController
  def show()
    begin
      @api_client = GoogleBooksApiClient.new(query_params())
      parsed_response = @api_client.call
      @books = BookCollection.new(parsed_response).assemble
    rescue StandardError => e
      Rails.logger.info e.message
      render :index
    end
  end

  private

  def query_params()
    params.slice('query', 'page_number')
  end
end
