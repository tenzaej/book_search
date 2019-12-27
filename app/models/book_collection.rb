class BookCollection
  def initialize(raw_data)
    @raw_data = raw_data
  end

  def assemble
    @raw_data
      .fetch(:items, [])
      .map { Book.build_from_google_data(_1) }
  end
end
