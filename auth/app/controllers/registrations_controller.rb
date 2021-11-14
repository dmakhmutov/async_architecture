class RegistrationsController < Devise::RegistrationsController
  def create
    super
    resource.update!(role: :admin)

    event = {
      event_id: SecureRandom.uuid,
      event_version: "1",
      event_name: 'AccountCreated',
      event_time: Time.now.to_s,
      producer: 'auth_service',
      data: { public_id: resource.public_id, email: resource.email, role: resource.role }
    }

    result = SchemaRegistry.validate_event(event, 'accounts.created', version: 1)

    if result.success?
      KafkaProducer.produce_sync(topic: 'accounts-stream', payload: event.to_json)
    else
      raise result.failure
    end
  end
end
