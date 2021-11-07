class ReassignsController < ApplicationController
  def create
    account_ids = Account.where(role: :dev).pluck(:id, :public_id)

    return if account_ids.empty?

    Task.where(status: :created).find_each do |task|
      account_id = account_ids.sample
      task.update!(assignee_id: account_id.first)

      event = {
        event_name: 'TaskAssigned',
        data: { public_id: task.public_id, assignee_id: account_id.second }
      }
      WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks')

      event = {
        event_name: 'TaskUpdated',
        data: { public_id: task.public_id, assignee_id: account_id.second }
      }
      WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks-stream')
    end

    redirect_to "/"
  end
end
