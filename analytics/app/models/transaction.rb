class Transaction < ApplicationRecord
  scope :today, -> { where(created_at: Date.current.beginning_of_day..Date.current.end_of_day) }
  # here should be some sort of types, by I'm lazy ass :)
  scope :task_assigning, -> { where(title: "For task assigning") }
  scope :task_completed, -> { where(title:  "For task completing") }
end
