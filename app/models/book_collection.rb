class BookCollection
  def initialize(raw_data)
    @raw_data = raw_data
  end

  def assemble
    @raw_data
      .fetch('items', [])
      .map { |response| Book.build_from_google_data(response) }
  end
end
