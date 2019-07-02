class BookCollection
  def initialize(raw_data)
    @raw_data = raw_data
  end

  def assemble
    @raw_data
      .fetch('items', [])
      .map { |response| Book.new(response) }
  end
end
