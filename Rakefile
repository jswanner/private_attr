require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.name = 'spec'
  t.pattern = 'spec/**/*_spec.rb'
  t.warning = true
end

task default: :spec
