class DashboardsController < ApplicationController
  def index
    @business_earned_money = -Transaction.today.task_assigning.sum(:amount) - Transaction.today.task_completed.sum(:amount)
    @popug_counts_earned_nothing = Transaction.today.task_assigning.where(task_id: Transaction.today.task_completed.pluck(:task_id).uniq).pluck(:account_id).uniq.count
    @most_high_task_for_day = Task.done.today.by_highest_cost.first
    @most_high_task_for_week = Task.done.week.by_highest_cost.first
    @most_high_task_for_month = Task.done.month.by_highest_cost.first
  end
end
