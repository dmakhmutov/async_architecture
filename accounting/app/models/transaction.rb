class Transaction < ApplicationRecord
  STATUSES = %w(pending completed).freeze

  belongs_to :task
  belongs_to :account

  enum status: STATUSES.zip(STATUSES).to_h, _default: "pending"

  scope :today, -> { where(created_at: Date.current.beginning_of_day..Date.current.end_of_day) }
end
