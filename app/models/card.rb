class Card < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :wants
  has_many :wanting_users, through: :wants, source: :user

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: ['for sale', 'not for sale'] }
  validates :card_type, presence: true, inclusion: { in: ['baseball', 'pokemon', 'football'] }
  validates :image, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.00 }, allow_nil: true

  # Format price for display
  def formatted_price
    price.present? ? sprintf("$%.2f", price) : nil
  end

  def want_text
    return nil if wants.empty?
    
    names = wanting_users.map(&:first_name)
    case names.length
    when 1
      "#{names.first} wants this"
    when 2
      "#{names.join(' and ')} want this"
    else
      "#{names[0..-2].join(', ')} and #{names.last} want this"
    end
  end
end
