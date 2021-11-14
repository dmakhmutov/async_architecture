class TasksStreamConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      payload = message.payload
      data = payload["data"]

      case payload["event_name"]
      when "TaskCreated"
        task = Task.upsert(public_id: data["public_id"])
        task.update!(
          assignee_id: data["assignee_id"],
          creator_id: data["creator_id"],
          status: data["status"],
          description: data["description"],
          cost: rand(10..20),
          reward: rand(20..40)
        )
      when "TaskUpdated"
        task = Task.upsert(public_id: data["public_id"])
        task.update!(assignee_id: data["assignee_id"], status: data["status"])
      end
    end
  end
end
