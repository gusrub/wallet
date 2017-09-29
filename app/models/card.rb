class Card < ApplicationRecord

  include Concerns::Paginable

  belongs_to :user

  has_secure_token :bank_token

  ISSUERS = %w(amex visa mastercard dinners discover)

  enum card_type: {
    credit: 0,
    debit: 1
  }

  enum status: {
    active: 0,
    removed: 1
  }

  validates :card_type, presence: true, inclusion: { in: self.card_types.keys }
  validates :last_4, presence: true, length: { is: 4 }
  validates :issuer, presence: true, inclusion: { in: ISSUERS }
  validates :status, presence: true, inclusion: { in: self.statuses.keys }
  validates :user, presence: true
  validates :expiration, presence: true

  before_validation :override_expiration_day
  before_validation :enable_card, only: :create

  scope :expired, -> { where("expiration <= ?", Time.now.strftime("%Y/%m/%d")) }

  private

  def override_expiration_day
    if expiration.present?
      self.expiration = self.expiration.strftime("%Y/%m/01")
    end
  end

  def enable_card
    self.status = Card.statuses[:active]
  end

end
