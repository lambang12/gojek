scheduler = Rufus::Scheduler::singleton

scheduler.every '5s' do
  ::MessagingService.consume_driver_allocation
  # ::AllocationService.find_initialized_orders
end

scheduler.every '10s' do
  ::AllocationService.find_initialized_orders
end
