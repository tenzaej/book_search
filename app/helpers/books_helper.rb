module BooksHelper
  def calculate_page_range(page_number, count)
    start_point = page_number - 5
    end_point   = (count < 10 ? page_number : page_number + 5)
    (start_point..end_point).select(&:positive?)
  end

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
