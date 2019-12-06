# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb'] # optional
  t.options = ['--any', '--extra', '--opts'] # optional
  t.stats_options = ['--list-undoc']         # optional
end

task default: :spec
