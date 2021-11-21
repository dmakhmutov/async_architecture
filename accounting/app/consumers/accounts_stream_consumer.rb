class AccountsStreamConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      payload = message.payload
      data = payload["data"]

      case payload["event_name"]
      when "AccountCreated"
        Account.create!(email: data["email"], public_id: data["public_id"], role: data["role"], balance: 0)
      when "AccountUpdated"
        Account.find_by(public_id: data["public_id"]).update!(role: data["role"])
      end
    end
  end
end
