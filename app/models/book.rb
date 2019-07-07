class Book
  attr_reader :title, :authors, :publisher, :thumbnail, :info_link

  def initialize(options)
    @title = options['title']
    @authors = options['authors']
    @publisher = options['publisher']
    @thumbnail = options['thumbnail']
    @info_link = options['info_link']
  end

  def self.build_from_google_data(raw_data)
    new(processed_google_response(raw_data))
  end

  private

  def self.processed_google_response(raw_data)
    book_info = raw_data['volumeInfo']
    book_info.merge({'info_link' => book_info.dig('infoLink'),
                      'thumbnail' => book_info.dig('imageLinks', 'smallThumbnail')})
  end
end
