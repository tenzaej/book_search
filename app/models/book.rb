class Book
  attr_reader :title, :authors, :publisher, :thumbnail, :info_link

  def initialize(raw_data)
    volume_info = raw_data['volumeInfo']
    @title = volume_info.dig('title')
    @authors = volume_info.dig('authors')
    @publisher = volume_info.dig('publisher')
    @thumbnail = volume_info.dig('imageLinks','smallThumbnail')
    @info_link = volume_info.dig('infoLink')
  end
end
