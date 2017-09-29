class Token < ApplicationRecord
  belongs_to :user

  has_secure_token

  enum token_type: {
    session: 0,
    account_confirmation: 1,
    password_reset: 2,
    email_change: 3
  }

  validates :token_type, presence: true, inclusion: { in: self.token_types.keys }
  validates :user, presence: true

  before_create :set_expiration, on: :create

  private

  def set_expiration
    self.expires_at = if session?
                        24.hours.from_now
                      elsif account_confirmation?
                        3.days.from_now
                      elsif password_reset?
                        3.days.from_now
                      elsif email_change?
                        3.days.from_now
                      end
  end
end
