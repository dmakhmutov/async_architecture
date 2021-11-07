class SelfTasksController < ApplicationController
  def index
    @tasks = Task.where(assignee_id: current_account.id)
  end

  def update
    task = Task.find(params[:id])
    task.update!(status: :done)


    event = {
      event_name: 'TaskCompleted',
      data: {
        public_id: task.public_id,
        status: task.status,
      }
    }
    WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks')

    event = {
      event_name: 'TaskUpdated',
      data: {
        public_id: task.public_id,
        status: task.status,
      }
    }
    WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream')

    redirect_to "/"
  end
end
