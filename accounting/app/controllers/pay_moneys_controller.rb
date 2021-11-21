class PayMoneysController < ApplicationController
  def create
    # It supposed to be some crone/sidekiq-cron-job/whenever/etc but I've decided just use this endpoint
    TransactionsCompleter.new.call

    redirect_to "/"
  end
end
