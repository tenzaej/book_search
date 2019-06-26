require 'rails_helper'

RSpec.describe BooksController do
  scenario 'going to the home page' do
    visit '/'
    expect(page).to have_content('Book Search')
    expect(page).to have_selector('#query-input')
  end

  scenario 'displays a list of books matching that query' do
    class_double('Net::HTTP')
    expect(Net::HTTP).to receive(:get).and_return(File.read('spec/data/full-response.json'))

    visit '/'
    within('#books-form') { fill_in 'query', with: 'Cybernetics' }
    click_button 'Search'

    within('#book-results') do
      expect(page).to have_selector('.book-listing', count: 10)
      expect(page).to have_selector('img')
      expect(page).to have_selector('p', text: /Norbert Wiener/)
      expect(page).to have_selector('p', text: /Cybernetics Or Control and Communication in the Animal and the Machine/)
      expect(page).to have_selector('p', text: /MIT Press/)
      expect(page).to have_link('Go to book listing on Google Books', href: 'http://books.google.com/books?id=NnM-uISyywAC&printsec=frontcover&dq=Norbert+Wiener&hl=&cd=1&source=gbs_api')
    end
  end

  scenario 'does not display book list if the response is blank' do
    class_double('Net::HTTP')
    expect(Net::HTTP).to receive(:get).and_return({"kind"=>"books#volumes", "totalItems"=>0}.to_json)

    visit '/'
    within('#books-form') { fill_in 'query', with: 'foobarbazquux' }
    click_button 'Search'

    expect(page).to_not have_selector('#book-results')
  end

  feature 'pagination' do
    scenario 'when no query has been made' do
      visit '/'

      expect(page).to_not have_selector('ul.pagination')
    end

    scenario 'when a query has been made and there are results' do
      class_double('Net::HTTP')
      expect(Net::HTTP).to receive(:get).and_return(File.read('spec/data/full-response.json'))

      visit '/'
      within('#books-form') { fill_in 'query', with: 'Cybernetics' }
      click_button 'Search'

      within('ul.pagination') do
        expect(page).to_not have_selector('li.previous-button')
        expect(page).to have_selector('li.page-number', count: 6)
        expect(page).to have_selector('li.next-button')
      end
    end

    scenario 'when a query has been made and there are results' do
      class_double('Net::HTTP')
      expect(Net::HTTP).to receive(:get).and_return(File.read('spec/data/full-response.json'))

      visit '/books?query=Cybernetics&page_number=8'

      within('ul.pagination') do
        expect(page).to have_selector('li.next-button')
        expect(page).to have_selector('li.page-number', count: 11)
        expect(page).to have_selector('li.next-button')
      end
    end

  end
end
