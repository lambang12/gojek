scheduler = Rufus::Scheduler::singleton

unless defined?(Rails::Console) || File.split($0).last == 'rake' || Rails.env.test?
  scheduler.every '5s' do
    MessagingService.consume_driver_allocation
  end

  scheduler.every '10s' do
    AllocationService.find_initialized_orders
  end
end