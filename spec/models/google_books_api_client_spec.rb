require 'spec_helper'
require 'net/http'

RSpec.describe GoogleBooksApiClient do
  describe '#format_uri' do
    it 'formats the query string to specification' do
      complicated_title = 'A Sermon [on Amos iv. 12] preached at the funeral of ... W. Earle, etc'
      expect(GoogleBooksApiClient.format_uri(complicated_title)).
        to eq(URI('https://www.googleapis.com/books/v1/volumes?q=A%20Sermon%20[on%20Amos%20iv.%2012]%20preached%20at%20the%20funeral%20of%20...%20W.%20Earle,%20etc'))
    end
  end
  describe '#call' do
    let(:response) do
      {"kind" => "books#volumes", "totalItems" => 12, "items" => []}
    end

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
      GoogleBooksApiClient.new('Jonathon Swift').call

      expect(Net::HTTP).to have_received(:get)
    end

    it 'parses the JSON' do
      response_from_google = GoogleBooksApiClient.new('Joe Hill').call

      expect(response_from_google).to eq(response)
    end

    it 'returns an error with code, message if one is returned' do
      allow(Net::HTTP).to receive(:get).
                           and_return(error_response.to_json)

      expect{ GoogleBooksApiClient.new('Jonathon Swift').call }.
        to raise_error(GoogleBooksApiClient::GoogleBooksApiError)
    end
  end
end
