require 'net/http'

class HttpClient
  class ErrorResponse < StandardError; end

  attr_accessor :strategy

  def initialize(strategy)
    @strategy = strategy
  end

  def call
    strategy.call(self)
  end

  def get
    prepared_uri = URI(strategy.uri)
    Net::HTTP.get(prepared_uri)
  rescue StandardError => e
    Rails.logger.info e.message
    raise
  end
end
