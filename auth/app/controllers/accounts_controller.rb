class AccountsController < ApplicationController
  def index
    @accounts = Account.all
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    account = Account.find(params[:id])
    account.update!(account_params)

    event = {
      event_id: SecureRandom.uuid,
      event_version: "1",
      event_name: 'AccountUpdated',
      event_time: Time.now.to_s,
      producer: 'auth_service',
      data: { public_id: resource.public_id, role: resource.role }
    }

    result = SchemaRegistry.validate_event(event, 'accounts.updated', version: 1)

    if result.success?
      KafkaProducer.produce_sync(topic: 'accounts-stream', payload: event.to_json)
    else
      raise result.failure
    end

    redirect_to "/"
  end

  def me
    account = Account.find(doorkeeper_token.resource_owner_id)

    render json: { public_id: account.public_id, email: account.email, role: account.role }
  end

  private

  def account_params
    params.require(:account).permit(:role)
  end
end
