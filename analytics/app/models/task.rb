class Task < ApplicationRecord
  STATUSES = %w(created done ptichka_v_kletke proso_v_miske).freeze

  belongs_to :account, optional: true
  belongs_to :assignee, class_name: "Account", optional: true

  enum status: STATUSES.zip(STATUSES).to_h, _default: "created"

  scope :today, -> { where(created_at: Date.current.beginning_of_day..Date.current.end_of_day) }
  scope :week, -> { where(created_at: Date.current.beginning_of_week..Date.current.end_of_week) }
  scope :month, -> { where(created_at: Date.current.beginning_of_month..Date.current.end_of_month) }
  scope :by_highest_cost, -> { order(cost: :desc) }
end
