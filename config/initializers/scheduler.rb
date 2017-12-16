scheduler = Rufus::Scheduler::singleton

scheduler.every '5s' do
  MessagingService.consume_driver_allocation
end
