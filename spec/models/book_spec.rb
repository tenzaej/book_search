require 'spec_helper'

RSpec.describe Book do
  describe '#initialize' do
    context 'when fields are present, sets all instance variables' do
      let(:raw_data) do
        {
          'volumeInfo' => {
            'title' => 'Teatro Grottesco',
            'authors' => ['Thomas Ligotti'],
            'publisher' => 'Random House',
            'imageLinks' => {'smallThumbnail' => 'http://link.to/image.png'},
            'infoLink' => 'http://link.to/info'
          }
        }
      end

      specify { expect(Book.new(raw_data).title).to eq('Teatro Grottesco') }
      specify { expect(Book.new(raw_data).authors).to eq(['Thomas Ligotti']) }
      specify { expect(Book.new(raw_data).publisher).to eq('Random House') }
      specify { expect(Book.new(raw_data).thumbnail).to eq('http://link.to/image.png') }
      specify { expect(Book.new(raw_data).info_link).to eq('http://link.to/info') }
    end

    context 'when field(s) are absent, set to null' do
      let(:raw_data) { { 'volumeInfo' => {} } }

      specify { expect(Book.new(raw_data).title).to be_nil }
      specify { expect(Book.new(raw_data).authors).to be_nil }
      specify { expect(Book.new(raw_data).publisher).to be_nil }
      specify { expect(Book.new(raw_data).thumbnail).to be_nil }
      specify { expect(Book.new(raw_data).info_link).to be_nil }
    end
  end
end
