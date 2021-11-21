class TasksStreamConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      payload = message.payload
      data = payload["data"]

      case payload["event_name"]
      when "TaskAdded"
        assigned_account = Account.find_by(public_id: data.fetch("assignee_id"))
        creator_account = Account.find_by(public_id: data.fetch("creator_id"))
        task = Task.create!(public_id: data["public_id"], assignee_id: assigned_account.id,
          creator_id: creator_account.id, status: "created",
          description: data["description"], cost: rand(10..20), reward: rand(20..40)
        )

        event = {
          event_name: 'TaskCostGenerated',
          data: { public_id: task.public_id, cost: task.cost, reward: task.reward }
        }
        WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream')
      when "TaskUpdated"
        task = Task.find_by(public_id: data["public_id"])
        task.update!(status: data.fetch("status"))
      when "TaskCostGenerated"
        # do nothing
      end
    end
  end
end
