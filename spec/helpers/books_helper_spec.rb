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
end
