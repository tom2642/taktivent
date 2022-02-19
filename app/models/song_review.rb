class SongReview < ApplicationRecord
  belongs_to :song

  validates :rating, presence: true, numericality: { in: 0..5 }

  enum sentiment: [ :positive, :neutral, :negative ]
end
