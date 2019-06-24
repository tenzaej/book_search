require 'rails_helper'

RSpec.describe BooksController, type: :controller do                           #
  describe 'show' do
    before(:each) do
      class_double('Net::HTTP')
      expect(Net::HTTP).
        to receive(:get).
             and_return({'items' => []}.to_json)
    end
    it "accepts a 'query' parameter" do
      get :show, params: {query: 'ligotti'}

      expect(assigns[:query]).to eq('ligotti')
    end

    it 'calls off to the Google Books API endpoint with the query parameter' do
      get :show, params: {query: 'ligotti'}

      expect(assigns[:books]).to eq({'items' => []})
    end
  end
end
