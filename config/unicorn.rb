worker_processes ENV.fetch("UNICORN_WORKERS", 3).to_i
timeout 30 # nuke workers after 30 seconds
preload_app true

before_fork do |_server, _worker|
  Signal.trap 'TERM' do
    defined?(Rails) and Rails.logger.warn 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  defined?(Redis) and $redis.client.disconnect
end

after_fork do |_server, _worker|
  Signal.trap 'TERM' do
    defined?(Rails) and Rails.logger.warn 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
