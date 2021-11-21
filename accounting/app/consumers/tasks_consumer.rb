class TasksConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      data = message.payload["data"]

      case message.payload["event_name"]
      when "TaskAssigned"
        task = Task.find_by!(public_id: data["public_id"])
        account = Account.find_by!(public_id: data["assignee_id"])
        transaction = Transaction.create!(title: "For task assigning", task_id: task.id, amount: -task.cost.to_i, account_id: account.id)
        account.update!(balance: account.balance.to_i - task.cost.to_i)

        transaction_producer(transaction)
      when "TaskCompleted"
        task = Task.find_by!(public_id: data["public_id"])
        account = Account.find_by!(public_id: task.assignee.public_id)
        transaction = Transaction.create!(title: "For task completing", task_id: task.id, account_id: account.id, amount: task.reward.to_i)
        account.update!(balance: account.balance.to_i + task.reward.to_i)

        transaction_producer(transaction)
      end
    end
  end

  def transaction_producer(transaction)
    event = { event_id: SecureRandom.uuid, event_version: "1",
      event_name: 'TransactionAdded',
      event_time: Time.now.to_s,
      producer: 'accounting_service',
      data: { task_id: transaction&.task&.public_id, account_id: transaction&.account&.public_id }.merge(transaction.slice(:public_id, :amount, :title))
    }

    result = SchemaRegistry.validate_event(event, 'transactions.added', version: 1)
    result.success? ? WaterDrop::SyncProducer.call(event.to_json, topic: 'transactions-stream') : raise(result.failure)
  end
end
