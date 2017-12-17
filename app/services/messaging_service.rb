module MessagingService
  def self.produce_order(order)
    topic = "#{RdKafka::TOPIC_PREFIX}orders"
    producer = RdKafka.producer({ "group.id": "orders0" })

    message = order.to_json
    puts "Producing message #{message}"
    producer.produce(
        topic:   topic,
        payload: message,
        key:     "Key #{order.id}"
    ).wait
  end

  def self.consume_driver_allocation
    topic = "#{RdKafka::TOPIC_PREFIX}allocated-drivers"
    consumer = RdKafka.consumer({ "group.id": "drivers-consumer1" })
    
    puts 'consume'
    consumer.subscribe(topic)

    begin
      consumer.each do |message|
        puts "Message received: #{message}"
        details = JSON.parse(message.payload)
        AllocationService.allocate_driver_to_order(details)
      end
    rescue Rdkafka::RdkafkaError => e
      retry if e.is_partition_eof?
      raise
    end
  end

  def self.produce_user(user)
    topic = "#{RdKafka::TOPIC_PREFIX}users"
    producer = RdKafka.producer({ "group.id": "users0" })

    message = user.to_json
    puts "Producing message #{message}"
    producer.produce(
        topic:   topic,
        payload: message,
        key:     "Key #{user.id}"
    ).wait
  end
end
