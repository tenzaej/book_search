require 'rails_helper'

RSpec.describe BooksController do
  scenario 'going to the home page' do
    visit '/'
    expect(page).to have_content('Hello, World')
  end

  scenario 'type in a query and display a list of books matching that query' do
    visit '/'
    within('#books-form') do
      fill_in 'query', with: 'ligotti'
    end
    click_button 'Search'

    expect(page).to have_selector('#book-results')
    expect()
  end
end
