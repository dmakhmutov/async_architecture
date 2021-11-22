class TasksStreamConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      payload = message.payload
      data = payload["data"]

      case payload["event_name"]
      when "TaskAdded"
        assigned_account = Account.find_by(public_id: data.fetch("assignee_id"))
        creator_account = Account.find_by(public_id: data.fetch("creator_id"))
        Task.create!(public_id: data["public_id"], assignee_id: assigned_account.id,
          creator_id: creator_account.id, status: "created",
          description: data["description"]
        )
      when "TaskUpdated"
        task = Task.find_by(public_id: data["public_id"])
        task.update!(status: data.fetch("status"))
      when "TaskCostGenerated"
        task = Task.find_by(public_id: data["public_id"])
        task.update!(cost: data["cost"], reward: data["reward"])
      end
    end
  end
end
