class Task < ApplicationRecord
  STATUSES = %w(created done).freeze

  belongs_to :assignee, class_name: "Account"

  enum status: STATUSES.zip(STATUSES).to_h, _default: "created"
end
