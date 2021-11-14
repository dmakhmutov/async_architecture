class Account < ApplicationRecord
  ROLES = %w(admin dev).freeze

  enum role: ROLES.zip(ROLES).to_h

  has_many :tasks
  has_many :transactions
end
