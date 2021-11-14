class TransactionsController < ApplicationController
  def index
    @transactions = account.transactions.today
  end

  private

  def account
    Account.find(params[:account_id])
  end
end
