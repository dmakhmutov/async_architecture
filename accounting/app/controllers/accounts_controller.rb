class AccountsController < ApplicationController
  def index
    @accounts = Account.all
    @earning_money = - Task.today.done.pluck(:reward).sum + Task.today.pluck(:cost).sum
  end
end
