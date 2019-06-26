require 'rails_helper'

RSpec.describe BooksHelper, type: :helper do
  describe '#generate_links' do
    let(:a_publisher) { 'Leanpub' }
    let(:some_authors) { ['Gilles Deleuze', 'Felix Guattari'] }

    it "returns 'None Listed' if the field is nil" do
      actual = helper.generate_links(nil)
      expect(actual).to have_selector('p', text: 'None Listed')
    end

    it 'turns a single item into a single link' do
      actual = helper.generate_links('Leanpub')
      expect(actual).to have_link('Leanpub', href: '/books?query=Leanpub')
    end

    it 'turns a collection of items into a collection of links' do
      actual = helper.generate_links(['Gilles Deleuze','Felix Guattari'])
      expect(actual).to have_link('Gilles Deleuze', href: '/books?query=Gilles+Deleuze')
      expect(actual).to have_link('Felix Guattari', href: '/books?query=Felix+Guattari')
    end
  end

  describe '#calculate_page_range' do
    it 'handles a nil count, incase someone went forward too many pages' do
      expect(calculate_page_range(7, 0)).to eq((2..7).to_a)
    end
    it 'does not show more next-pages if there are fewer than 10 books' do
      expect(calculate_page_range(7, 3)).to eq((2..7).to_a)
    end
    it 'does not show negative page numbers' do
      expect(calculate_page_range(3, 10)).to eq((1..8).to_a)
    end
    it 'attempts to show the range of +5/-5, given the current page' do
      expect(calculate_page_range(7, 10)).to eq((2..12).to_a)
    end
  end
end
