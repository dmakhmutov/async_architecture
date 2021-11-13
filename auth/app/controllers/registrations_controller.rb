class RegistrationsController < Devise::RegistrationsController
  def create
    super
    resource.update!(role: :admin)

    event = {
      event_name: 'AccountCreated',
      data: { public_id: resource.public_id, email: resource.email, role: resource.role }
    }

    KafkaProducer.produce_sync(topic: 'accounts-stream', payload: event.to_json)
  end
end
