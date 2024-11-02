class Card < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  
  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: ['for sale', 'not for sale'] }
  validates :card_type, presence: true, inclusion: { in: ['baseball', 'pokemon', 'football'] }
  validates :image, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.00 }, allow_nil: true

  # Format price for display
  def formatted_price
    price.present? ? sprintf("$%.2f", price) : nil
  end
end
