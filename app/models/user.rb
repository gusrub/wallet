class User < ApplicationRecord

  has_secure_password

  enum role: {
    customer: 0,
    admin: 1
  }

  enum status: {
    active: 0,
    unconfirmed: 1,
    disabled: 2
  }

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true, inclusion: { in: self.roles.keys }
  validates :status, presence: true, inclusion: { in: self.statuses.keys }  
  validates :password, length: { minimum: 8 }, allow_nil: true
end
