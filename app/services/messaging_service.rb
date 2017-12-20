class MessagingService
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

    puts "consume #{topic}"
    consumer.subscribe(topic)

    begin
      consumer.each do |message|
        puts "Message received: #{message}"
        details = RequestResponse.json_to_hash(message.payload)
        ::AllocationService.allocate_driver_to_order(details)
      end
    rescue Rdkafka::RdkafkaError => e
      retry if e.is_partition_eof?
      raise
    end
  end

  def self.produce_order_cancellation(order)
    topic = "#{RdKafka::TOPIC_PREFIX}order-cancellation"
    producer = RdKafka.producer({ "group.id": "order-cancellation0" })

    message = order.to_json
    puts "Producing message #{message}"
    producer.produce(
        topic:   topic,
        payload: message,
        key:     "Key #{order.id}"
    ).wait
  end
end
