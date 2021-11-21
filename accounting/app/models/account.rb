class Account < ApplicationRecord
  ROLES = %w(admin dev).freeze

  enum role: ROLES.zip(ROLES).to_h
end
