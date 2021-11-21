class SelfTasksController < ApplicationController
  def index
    @tasks = Task.where(assignee_id: current_account.id)
  end

  def update
    task = Task.find(params[:id])
    task.update!(status: :done)

    event = {
      event_id: SecureRandom.uuid,
      event_version: "1",
      event_name: 'TaskCompleted',
      event_time: Time.now.to_s,
      producer: 'tasks_service',
      data: { public_id: task.public_id, status: task.status }
    }

    result = SchemaRegistry.validate_event(event, 'tasks.completed', version: 1)
    result.success? ? WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks') : raise result.failure

    event = {
      event_id: SecureRandom.uuid,
      event_version: "1",
      event_name: 'TaskUpdated',
      event_time: Time.now.to_s,
      producer: 'tasks_service',
      data: { public_id: task.public_id, status: task.status }
    }

    result = SchemaRegistry.validate_event(event, 'tasks.updated', version: 1)
    result.success? ? WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream') : raise result.failure

    redirect_to "/"
  end
end
