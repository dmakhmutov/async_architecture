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
      event_name: 'AccountUpdated',
      data: { public_id: account.public_id, role: account.role }
    }
    KafkaProducer.produce_sync(topic: 'accounts-stream', payload: event.to_json)

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
