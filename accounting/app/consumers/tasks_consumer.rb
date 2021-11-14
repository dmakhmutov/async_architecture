class TasksConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      data = message.payload["data"]

      case message.payload["event_name"]
      when "TaskAssigned"
        task = Task.find_by(public_id: data["public_id"])
        account = Account.find_by(public_id: data["assignee_id"]).balance
        Transaction.create!(title: "For task assigning", task: task, balance: account.balance, amount: -task.cost)
        account.update!(balance: account.balance - task.cost)
      when "TaskCompleted"
        task = Task.find_by(public_id: data["public_id"])
        account = Account.find_by(public_id: task.assignee_id)
        Transaction.create!(title: "For task completing", task: task, account: account, amount: task.reward)
      end
    end
  end
end
