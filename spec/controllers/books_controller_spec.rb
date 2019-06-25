require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let("api_client") { double(:api_client, {call: ['list of books data']}) }

  describe 'show' do
    before(:each) do
      class_double('GoogleBooksApiClient')
      class_double('BookCollection')
      allow(GoogleBooksApiClient).to receive(:new).and_return(api_client)
      allow(BookCollection).to receive_message_chain(:new, :assemble).and_return(['books'])
    end

    it "assigns the query and books" do
      get :show, params: {query: ' ligotti  '}
      expect(assigns[:query]).to eq('ligotti')
      expect(assigns[:books]).to eq(['books'])
    end

    it 'calls off to the Google Books API endpoint with the query parameter' do
      get :show, params: {query: 'ligotti'}
      expect(GoogleBooksApiClient).to have_received(:new).with('ligotti')
      expect(api_client).to have_received(:call)
    end

    it 'assembles a BookCollection based on response from the API call' do
      get :show, params: {query: 'ligotti'}
      expect(BookCollection).to have_received(:new).with(['list of books data'])
    end

    context 'when no books are returned from Google Books API' do
      let(:message) { "Google Books API returned zero results for query 'the rarest book ever'" }
      let("rails_logger") { double(:rails_logger, {info: nil}) }

      before(:each) do
        allow(api_client).
          to receive(:call).
               and_raise(GoogleBooksApiClient::EmptyResponse.new(message))
        class_double('Rails')
        allow(Rails).to receive(:logger).and_return(rails_logger)
      end

      it 'renders the index page' do
        get :show, params: {query: 'the rarest book ever'}

        expect(response).to render_template(:index)
      end

      it 'logs some info' do
        get :show, params: {query: 'FOOBAR'}

        expect(rails_logger).to have_received(:info).with(message)
      end
    end

    context 'when an error is returned by Google Books' do
      let(:message) { "Google Books API returned a code 500 with the message 'Internal Server Error'" }
      let("rails_logger") { double(:rails_logger, {info: nil}) }

      before(:each) do
        allow(api_client).
          to receive(:call).
               and_raise(GoogleBooksApiClient::ErrorResponse.new(message))
        class_double('Rails')
        allow(Rails).to receive(:logger).and_return(rails_logger)
      end

      it 'renders the index page' do
        get :show, params: {query: 'FOOBAR'}

        expect(response).to render_template(:index)
      end

      it 'logs an error' do
        get :show, params: {query: 'FOOBAR'}

        expect(rails_logger).to have_received(:info).with(message)
      end
    end
  end
end
