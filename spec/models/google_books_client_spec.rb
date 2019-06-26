require 'rails_helper'
require 'net/http'
require './app/models/google_books_client'

RSpec.describe GoogleBooksClient do
  describe '#call' do
    let(:response) { {"items" => []} }
    let(:uri) { URI('https://www.googleapis.com/books/v1/volumes?q=Rich%20Hickey&fields=items(volumeInfo(title,authors,publisher,infoLink,imageLinks(smallThumbnail)))&startIndex=20') }
    let(:error_response) do
      {"error" => {"errors" => [], "code" => 400, "message" => "Missing query."}}
    end

    before(:each) do
      class_double('Net::HTTP')
      allow(Net::HTTP).
        to receive(:get).
             and_return(response.to_json)
    end

    it 'calls off to Google Books API' do
      GoogleBooksClient.new({'query' => 'Rich Hickey', 'page_number' => 3}).call

      expect(Net::HTTP).to have_received(:get).with(uri)
    end

    it 'parses the JSON' do
      response_from_google = GoogleBooksClient.new({'query' => 'Joe Hill'}).call

      expect(response_from_google).to eq(response)
    end

    it 'returns an error with code, message if one is returned' do
      allow(Net::HTTP).to receive(:get).
                           and_return(error_response.to_json)

      expect {
        GoogleBooksClient.new({'query' => 'INVALID QUERY!!' }).call
      }.to raise_error(GoogleBooksClient::ErrorResponse)
    end

    it 'gets its query' do
      expect(GoogleBooksClient.new({'query' => 'Rich'}).query).to eq('Rich')
    end

    describe '#page_number' do
      it 'gets its formatted page_number' do
        expect(GoogleBooksClient.new({'page_number' => '7'}).page_number).to eq(7)
      end

      it 'defaults to 1 if 0 is sent in' do
        expect(GoogleBooksClient.new({'page_number' => 0}).page_number).to eq(1)
      end

      it 'defaults to 1 if page_number parameter is missing' do
        expect(GoogleBooksClient.new().page_number).to eq(1)
      end
    end
  end
end
