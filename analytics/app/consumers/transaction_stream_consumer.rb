class TransactionStreamConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      payload = message.payload
      data = payload["data"]

      case payload["event_name"]
      when "TransactionAdded"
        Transaction.create!(
          public_id: data.fetch("public_id"),
          amount: data.fetch("amount"),
          status: "pending",
          title: data.fetch("title"),
          account_id: Account.find_by!(public_id: data.fetch("account_id")).id,
          task_id: Task.find_by(public_id: data.fetch("task_id"))
        )
      end
    end
  end
end
