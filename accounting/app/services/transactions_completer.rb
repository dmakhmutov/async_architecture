class TransactionsCompleter
  def initialize
    @transactions = Transaction.pending
  end

  def call
    transactions.group_by(&:account_id).each do |account_id, transactions|
      account = Account.find(account_id)
      total_amount = transactions.sum(&:amount)

      pay_money(account, total_amount) if total_amount > 0

      complete_all_pending_transactions(transactions)
      send_email_notification(account)
    end
  end

  private

  attr_reader :transactions

  def pay_money(account, total_amount)
    transaction = Transaction.create!(title: "Payment for today", amount: -total_amount, account_id: account.id)
    # run some service and pay money
    account.update!(balance: 0)
    transaction.update!(status: "completed")
    transaction_producer(transaction)
  end

  def complete_all_pending_transactions(transactions)
    transactions.each { _1.update(status: "completed") }
  end

  def send_email_notification(_account) end

  def transaction_producer(transaction)
    event = { event_id: SecureRandom.uuid, event_version: "1",
      event_name: 'TransactionAdded',
      event_time: Time.now.to_s,
      producer: 'accounting_service',
      data: { task_id: transaction&.task&.public_id, account_id: transaction&.account&.public_id, task_id: "" }.merge(transaction.slice(:public_id, :amount, :title))
    }

    result = SchemaRegistry.validate_event(event, 'transactions.added', version: 1)
    result.success? ? WaterDrop::SyncProducer.call(event.to_json, topic: 'transactions-stream') : raise(result.failure)
  end
end
