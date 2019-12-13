require 'rails_helper'

RSpec.describe Book do
  describe '#build_from_google_data' do
    context 'sets instance variables from google books response map' do
      let(:volume) do
        {
          :volumeInfo => {
            :title => 'Teatro Grottesco',
            :authors => ['Thomas Ligotti'],
            :publisher => 'Random House',
            :imageLinks => {:smallThumbnail => 'http://link.to/image.png'},
            :infoLink => 'http://link.to/info'
          }
        }
      end

      specify { expect(Book.build_from_google_data(volume).title).to eq('Teatro Grottesco') }
      specify { expect(Book.build_from_google_data(volume).authors).to eq(['Thomas Ligotti']) }
      specify { expect(Book.build_from_google_data(volume).publisher).to eq('Random House') }
      specify { expect(Book.build_from_google_data(volume).thumbnail).to eq('http://link.to/image.png') }
      specify { expect(Book.build_from_google_data(volume).info_link).to eq('http://link.to/info') }
    end
  end
end
