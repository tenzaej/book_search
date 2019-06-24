require 'rails_helper'

RSpec.describe BooksController do
  scenario 'going to the home page' do
    visit '/'
    expect(page).to have_content('Hello, World')
  end

  scenario 'displays a list of books matching that query' do
    # given
    class_double('Net::HTTP')
    expect(Net::HTTP).to receive(:get).and_return(File.read('spec/data/full-ligotti-response.json'))

    # when
    visit '/'
    within('#books-form') { fill_in 'query', with: 'ligotti' }
    click_button 'Search'

    # then
    within('#book-list') do
      expect(page).to have_selector('.book-listing', count: 10)
      expect(page).to have_selector('p', text: /Thomas Ligotti/)
      expect(page).to have_selector('p', text: /Teatro Grottesco/)
      expect(page).to have_selector('p', text: /Random House/)
    end
  end
end
