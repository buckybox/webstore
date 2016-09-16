# frozen_string_literal: true

# directory '/var/app/current'
threads 8, 32
workers `grep -c processor /proc/cpuinfo`
preload_app!
# bind 'unix:///var/run/puma/my_app.sock'
# pidfile '/var/run/puma/puma.pid'
# stdout_redirect '/var/log/puma/puma.log', '/var/log/puma/puma.log', true
# daemonize false
