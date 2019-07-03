require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let('book_collection') { double(:book_collection, {}) }
  let!('parsed_response') do
    {'items' => [
       {'volumeInfo' => {
          'title' => 'Cybernetics',
          'authors' => ['Norbert Wiener'],
          'publisher' => 'MIT Press',
          'imageLinks' => {
            'smallThumbnail' => 'http://books.google.com/books/content?id=NnM-uISyywAC'
          },
          'infoLink' => 'http://books.google.com/books?id=NnM-uISyywAC'
        }}
     ]}
  end
  let('client') { double(:client, call: parsed_response) }

  describe 'show' do
    before(:each) do
      class_double('GoogleBooksClient')
      class_double('BookCollection')
      allow(GoogleBooksClient).to receive(:new).and_return(client)
      allow(BookCollection).to receive(:new).and_return(book_collection)
      allow(book_collection).to receive(:assemble).and_return(book_collection)
    end

    it 'assigns the client and books' do
      get :show, params: { query: 'Cybernetics' }
      expect(assigns[:client]).to eq(client)
      expect(assigns[:books]).to eq(book_collection)
    end

    it 'calls off to the Google Books API endpoint with the query parameter' do
      get :show, params: { query: 'Cybernetics' }
      expect(GoogleBooksClient).to have_received(:new).with('query' => 'Cybernetics')
      expect(client).to have_received(:call)
    end

    it 'assembles a BookCollection based on response from the API call' do
      get :show, params: { query: 'Cybernetics' }
      expect(BookCollection).to have_received(:new).with(parsed_response)
    end

    context 'when an error is returned by Google Books' do
      let(:message) { "Google Books API returned a code 500 with the message 'Internal Server Error'" }
      let('rails_logger') { double(:rails_logger, info: nil) }

      before(:each) do
        allow(client)
          .to receive(:call)
          .and_raise(GoogleBooksClient::ErrorResponse.new(message))
        class_double('Rails')
        allow(Rails).to receive(:logger).and_return(rails_logger)
      end

      it 'renders the show page' do
        get :show, params: { query: 'FOOBAR' }

        expect(response).to render_template(:show)
      end

      it 'populates the books variable with an empty array' do
        get :show, params: { query: 'FOOBAR' }

        expect(assigns[:books]).to eq([])
      end

      it 'logs an error' do
        get :show, params: { query: 'FOOBAR' }

        expect(rails_logger).to have_received(:info).with(message)
      end
    end
  end
end
