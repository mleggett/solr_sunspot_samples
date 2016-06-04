class Book < ActiveRecord::Base
  include Concerns::SearchDateRanges

  has_many :genres
  scope :publication_date, -> { order("publication_date DESC") }
  validates_uniqueness_of :isbn

  searchable do
    text :title, default_boost: 2
    text :description
    text :isbn
    text :authors
    date :filter_date { publication_date.to_date }
    integer :genre_ids, multiple: true
  end

end
