class BookCollection
  include Enumerable

  def initialize(raw_data)
    @raw_data = raw_data
    @books = []
  end

  def assemble()
    @books = @raw_data['items'].map do |response|
      Book.new(response)
    end
    self
  end

  def each(&block)
    @books.each(&block)
  end
end
