class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  after_initialize :generate_uuid

  protected

  def generate_uuid
    self.public_id = SecureRandom.uuid unless public_id
  end
end
