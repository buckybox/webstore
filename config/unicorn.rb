# frozen_string_literal: true

# unicorn -c .../current/config/unicorn.rb -E production

# Set the current app's path for later reference. Rails.root isn't available at
# this point, so we have to point up a directory
app_path = File.expand_path("#{__dir__}/..")

# Typically one worker per CPU core
worker_processes ENV.fetch("UNICORN_WORKERS", 2).to_i

# Set the working directory of this unicorn instance
working_directory app_path

# Load app into the master before forking workers for super-fast worker spawn times
preload_app true

# Restart any workers that haven't responded in 30 seconds
timeout 30

# Set the location of the unicorn pid file. This should match what we put in the
# unicorn init script later.
pid "#{app_path}/tmp/unicorn.pid"

# Listen on a Unix data socket
listen "#{app_path}/tmp/unicorn.sock", backlog: 64

# You should define your stderr and stdout here - if you don't, stderr defaults
# to /dev/null and you'll lose any error logging when in daemon mode
stderr_path "#{app_path}/log/unicorn.log"
stdout_path "#{app_path}/log/unicorn.log"

before_fork do |server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!
  defined?($redis) && $redis.client.disconnect

  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
      nil
    end
  end
end

after_fork do |_server, _worker|
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection

  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
  # Redis and Memcached would go here but their connections are established
  # on demand, so the master never opens a socket
end
