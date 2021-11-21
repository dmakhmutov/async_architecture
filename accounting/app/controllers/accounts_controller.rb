class AccountsController < ApplicationController
  def index
    @accounts = Account.all
    @earning_money = Transaction.today.sum(:amount) * (-1)
  end
end
