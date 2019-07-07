require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let('book_collection') { double(:book_collection) }
  let!('parsed_response') { {'items' => []} }
  let('client') { double(:client, call: parsed_response) }
  let('strategy') { double(:strategy) }

  describe 'show' do
    before(:each) do
      class_double('HttpClient')
      class_double('GoogleBooksStrategy')
      class_double('BookCollection')
      class_double('Rails')
      allow(Rails).to receive_message_chain(:cache, :fetch).and_yield
      allow(HttpClient).to receive(:new).and_return(client)
      allow(BookCollection).to receive(:new).and_return(book_collection)
      allow(GoogleBooksStrategy).to receive(:new).and_return(strategy)
      allow(book_collection).to receive(:assemble).and_return(book_collection)
    end

    it 'assigns local variables' do
      get :show, params: { query: 'Cybernetics', page: 4 }

      expect(assigns[:query]).to eq('Cybernetics')
      expect(assigns[:page]).to eq(4)
      expect(assigns[:books]).to eq(book_collection)
    end

    it 'assigns books from the cache when present' do
      class_double('Rails')
      allow(Rails).to receive_message_chain(:cache, :fetch).and_return(book_collection)

      get :show, params: {query: 'I Am A Strange Loop'}

      expect(assigns[:books]).to eq(book_collection)
      expect(GoogleBooksStrategy).to_not have_received(:new)
      expect(HttpClient).to_not have_received(:new).with(strategy)
      expect(client).to_not have_received(:call)
    end

    it 'calls off to the Google Books API endpoint with the query parameter' do
      get :show, params: { query: 'Cybernetics' }
      expect(GoogleBooksStrategy).to have_received(:new)
      expect(HttpClient).to have_received(:new).with(strategy)
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
          .and_raise(GoogleBooksStrategy::ErrorResponse.new(message))
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
