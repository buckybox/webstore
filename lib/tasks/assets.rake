# frozen_string_literal: true

namespace :assets do
  desc "Remove compiled assets and recompile them"
  task update: [:clobber, :precompile] do
    puts "Updated all assets"
  end
end
