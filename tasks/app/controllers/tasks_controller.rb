class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
  end

  def create
    task = Task.create!(task_params.merge(creator_id: current_account.id))

    event = {
      event_id: SecureRandom.uuid,
      event_version: "1",
      event_name: 'TaskAdded',
      event_time: Time.now.to_s,
      producer: 'tasks_service',
      data: {
        public_id: task.public_id, assignee_id: task.assignee.public_id,
        creator_id: current_account.public_id
      }.merge(task.slice(:description))
    }

    result = SchemaRegistry.validate_event(event, 'tasks.added', version: 1)
    result.success? ? WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream') : raise(result.failure)

    event = {
      event_id: SecureRandom.uuid,
      event_version: "1",
      event_name: 'TaskAssigned',
      event_time: Time.now.to_s,
      producer: 'tasks_service',
      data: { public_id: task.public_id, assignee_id: task.assignee.public_id }
    }

    result = SchemaRegistry.validate_event(event, 'tasks.assigned', version: 1)
    result.success? ? WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks') : raise(result.failure)

    redirect_to tasks_path
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    @task.update!(task_params)

    event = {
      event_id: SecureRandom.uuid,
      event_version: "1",
      event_name: 'TaskCompleted',
      event_time: Time.now.to_s,
      producer: 'tasks_service',
      data: { public_id: @task.public_id }
    }

    result = SchemaRegistry.validate_event(event, 'tasks.completed', version: 1)
    result.success? ? WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks') : raise(result.failure)

    event = {
      event_id: SecureRandom.uuid,
      event_version: "1",
      event_name: 'TaskUpdated',
      event_time: Time.now.to_s,
      producer: 'tasks_service',
      data: { public_id: @task.public_id, status: @task.status, assignee_id: task.assignee.publicid }
    }

    result = SchemaRegistry.validate_event(event, 'tasks.updated', version: 1)
    result.success? ? WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream') : raise(result.failure)

    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:description, :assignee_id, :status)
  end
end
