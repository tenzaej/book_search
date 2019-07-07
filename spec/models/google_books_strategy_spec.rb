require 'rails_helper'

RSpec.describe GoogleBooksStrategy do
  let(:params) { { query: 'Erlang', page: 2 } }
  let(:http_client) { double('http_client', get: { 'books' => [] }.to_json) }
  let(:error_response) do
    {'error' => {
       'errors' => [],
       'code' => 400,
       'message' => 'Missing query.'
     }}.to_json
  end

  describe '#call' do
    it 'makes a call using the http_client provided' do
      GoogleBooksStrategy.new(params).call(http_client)
      expect(http_client).to have_received(:get)
    end

    it 'returns the parsed response' do
      response = GoogleBooksStrategy.new(params).call(http_client)
      expect(response).to eq('books' => [])
    end

    it 'returns an error if the JSON contained an error' do
      allow(http_client)
        .to receive(:get)
        .and_return(error_response)

      expect {
        GoogleBooksStrategy.new(params).call(http_client)
      }.to raise_error(GoogleBooksStrategy::ErrorResponse)
    end
  end

  describe '#uri' do
    it 'correctly formats its uri' do
      uri = GoogleBooksStrategy.new(params).uri
      expect(uri)
        .to eq('https://www.googleapis.com/books/v1/volumes?q=Erlang&fields=items(volumeInfo(title,authors,publisher,infoLink,imageLinks(smallThumbnail)))&startIndex=10')
    end
  end
end
