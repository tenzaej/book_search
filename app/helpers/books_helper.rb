module BooksHelper
  def calculate_page_range(page, count)
    return [] if page == 1 && count.zero?
    start_point = page - 5
    end_point   = (count < 10 ? page : page + 5)
    (start_point..end_point).select(&:positive?)
  end

  def generate_links(field)
    return 'None Listed' unless field

    if field.respond_to?(:map)
      field
        .map { |item| link_to item, books_path(query: item) }
        .join(', ')
        .html_safe
    else
      link_to field, books_path(query: field).html_safe
    end
  end
end
