class Book
  READ_ONLY_FIELDS = [:title, :authors, :publisher, :thumbnail, :preview_link]

  attr_reader(*READ_ONLY_FIELDS)

  def initialize(raw_data)
    @raw_data = raw_data
    @title = format_title('title')
    @authors = format_authors('authors')
    @publisher = format_publisher('publisher')
    @thumbnail = format_thumbnail('imageLinks','smallThumbnail')
    @preview_link = format_preview_link('previewLink')
  end

  READ_ONLY_FIELDS.each do |field|
    define_method "format_#{field}".to_sym do |*keys|
      volume_info.dig(*keys)
    end
  end

  private

  def volume_info
    @raw_data['volumeInfo']
  end
end
