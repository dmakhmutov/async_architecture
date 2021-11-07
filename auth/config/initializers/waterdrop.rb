require 'water_drop'

KafkaProducer = WaterDrop::Producer.new

KafkaProducer.setup do |config|
  config.deliver = true
  config.kafka = {
    'bootstrap.servers': 'localhost:9092',
    'request.required.acks': 1
  }
end
