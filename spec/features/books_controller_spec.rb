require 'rails_helper'

RSpec.describe BooksController do
  scenario 'going to the home page' do
    visit '/'
    expect(page).to have_content('Book Search')
    expect(page).to have_selector('#query-input')
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
    within('#book-results') do
      expect(page).to have_selector('.book-listing', count: 10)
      expect(page).to have_selector('img')
      expect(page).to have_selector('p', text: /Thomas Ligotti/)
      expect(page).to have_selector('p', text: /Teatro Grottesco/)
      expect(page).to have_selector('p', text: /Random House/)
      expect(page).to have_link('Go to book listing on Google Books', href: 'http://books.google.com/books?id=9eoC_cGOPiEC&printsec=frontcover&dq=ligotti&hl=&cd=1&source=gbs_api')
    end
  end

  scenario 'does not display book list if the response is blank' do
    # given
    class_double('Net::HTTP')
    expect(Net::HTTP).to receive(:get).and_return({"kind"=>"books#volumes", "totalItems"=>0}.to_json)

    # when
    visit '/'
    within('#books-form') { fill_in 'query', with: 'foobarbazquux' }
    click_button 'Search'

    # then
    expect(page).to_not have_selector('#book-results')
  end
end
