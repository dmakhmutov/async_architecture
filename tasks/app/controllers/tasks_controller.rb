class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
  end

  def create
    task = Task.create!(task_params.merge(creator_id: current_account.id))

    event = {
      event_name: 'TaskCreated',
      data: {
        public_id: task.public_id,
      }.merge(task.slice(:assignee_id, :status, :creator_id, :description))
    }
    WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream')

    event = {
      event_name: 'TaskAssigned',
      data: { public_id: task.public_id, assignee_id: task.assignee_id }
    }
    WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks')

    redirect_to tasks_path
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    @task.update!(task_params)

    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:description, :assignee_id)
  end
end
