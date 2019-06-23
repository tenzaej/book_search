require 'rails_helper'

RSpec.describe BooksController do
  scenario 'the home page' do
    visit '/'
    expect(page).to have_content('Hello, World')
  end
end
