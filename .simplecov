SimpleCov.start do
  track_files "**/*.rb"

  add_filter "/config/environments/"
  add_filter "/config/unicorn.rb"
  add_filter "/features/support/env.rb"
  add_filter "/spec/"
  add_filter "/vendor/"
end

# vim: ft=ruby
