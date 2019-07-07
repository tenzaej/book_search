require 'rails_helper'
require 'net/http'

RSpec.describe HttpClient do
  let(:strategy) { double('strategy', uri: 'https://goodreads.com/search?q=erlang', call: true)}

  describe '#call' do
    it 'calls its strategy' do
      HttpClient.new(strategy).call

      expect(strategy).to have_received(:call)
    end
  end

  describe '#get' do
    before(:each) do
      class_double('Net::HTTP')
      allow(Net::HTTP)
        .to receive(:get)
        .and_return({'books' => []})
    end

    it "uses its strategy's uri" do
      HttpClient.new(strategy).get

      expect(strategy).to have_received(:uri)
    end

    it 'makes a Net::HTTP get request' do
      HttpClient.new(strategy).get

      expect(Net::HTTP).to have_received(:get).with(URI(strategy.uri))
    end

    it 'returns whatever the Net::HTTP request returns' do
      response = HttpClient.new(strategy).get

      expect(response).to eq({'books' => []})
    end

    it 'handles errors' do
      class_double('Rails')
      expect(Rails).to receive_message_chain(:logger, :info)

      allow(Net::HTTP)
        .to receive(:get)
        .and_raise(StandardError.new('api is down'))

      expect {
        HttpClient.new(strategy).get
      }.to raise_error(StandardError)
    end
  end
end
