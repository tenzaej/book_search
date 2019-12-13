require 'rails_helper'

RSpec.describe BookCollection do
  describe '#assemble' do
    let(:raw_datas) do
      { :items => [
          {
            :volumeInfo => {
              :title => "Teatro Grottesco",
              :authors => ["Thomas Ligotti"],
              :publisher => "Random House",
              :imageLinks => {:smallThumbnail => "http://link.to/image.png"},
              :infoLink => "http://link.to/info",
            }
          },
          {
            :volumeInfo => {
              :title => "Clean Code",
              :authors => ["Robert C. Martin"],
              :publisher => "Pearson Education",
              :imageLinks => {:smallThumbnail => "http://link.to/image.jpg"},
              :infoLink => "http://link.to/otherinfo",
            }
          },
        ]
      }
    end

    before(:each) do
      @book_collection = BookCollection.new(raw_datas).assemble
    end

    it 'populates its @books instance variable with new Books' do
      expect(@book_collection.count).to eq(2)
    end

    it 'responds to attempts at enumeration using its books collection' do
      expect(@book_collection.map(&:title)).to eq(["Teatro Grottesco", "Clean Code"])
    end
  end
end
