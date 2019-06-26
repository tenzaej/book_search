module BooksHelper
  def generate_links(field)
    return 'None Listed' unless field
    if field.respond_to?(:map)
      field.map do |item|
        link_to item, books_path(query: item)
      end.join(', ').html_safe
    else
      link_to field, books_path(query: field).html_safe
    end
  end

end
