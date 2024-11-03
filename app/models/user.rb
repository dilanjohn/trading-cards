class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cards, dependent: :destroy
  has_many :wants
  has_many :wanted_cards, through: :wants, source: :card

  validates :first_name, presence: true
  validates :status, inclusion: { in: %w[pending approved rejected] }

  after_create :check_whitelist

  scope :pending, -> { where(status: 'pending') }
  scope :approved, -> { where(status: 'approved') }
  scope :rejected, -> { where(status: 'rejected') }

  def active_for_authentication?
    super && status == 'approved'
  end

  def inactive_message
    status == 'approved' ? super : :not_approved
  end

  def full_name
    last_name.present? ? "#{first_name} #{last_name}" : first_name
  end

  private

  def check_whitelist
    if WhitelistedEmail.exists?(email: email.downcase)
      self.status = 'approved'
      self.approved = true
      save
    end
  end
end
