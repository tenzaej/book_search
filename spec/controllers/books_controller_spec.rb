require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let("api_client") { double(:api_client, {call: ['list of books']}) }

  describe 'show' do
    before(:each) do
      class_double('GoogleBooksApiClient')
      allow(GoogleBooksApiClient).to receive(:new).and_return(api_client)
    end

    it "assigns the 'query' parameter" do
      get :show, params: {query: 'ligotti'}
      expect(assigns[:query]).to eq('ligotti')
    end

    it 'calls off to the Google Books API endpoint with the query parameter' do
      get :show, params: {query: 'ligotti'}
      expect(GoogleBooksApiClient).to have_received(:new).with('ligotti')
      expect(api_client).to have_received(:call)
      expect(assigns[:books]).to eq(['list of books'])
    end

    context 'when an error is returned by Google Books' do
      let(:error) { "Google Books API returned a code 500 with the message 'Internal Server Error'" }
      let("rails_logger") { double(:rails_logger, {error: nil, info: nil}) }

      before(:each) do
        allow(api_client).
          to receive(:call).
               and_raise(GoogleBooksApiClient::GoogleBooksApiError.new(error))
        class_double('Rails')
        allow(Rails).to receive(:logger).and_return(rails_logger)
      end

      it 'renders the index page' do
        get :show, params: {query: 'FOOBAR'}

        expect(response).to render_template(:index)
      end

      it 'logs an error' do
        get :show, params: {query: 'FOOBAR'}

        expect(rails_logger).to have_received(:error).with(error)
      end
    end
  end
end
