class Task < ApplicationRecord
  STATUSES = %w(created done ptichka_v_kletke proso_v_miske).freeze

  belongs_to :account
  belongs_to :assignee, class_name: "Account"

  enum status: STATUSES.zip(STATUSES).to_h, _default: "created"

  scope :today, -> { where(created_at: Date.current.beginning_of_day..Date.current.end_of_day) }
end
