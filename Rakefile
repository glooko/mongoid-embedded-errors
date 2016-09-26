require 'rubygems'
require 'bundler/setup'

Bundler::GemHelper.install_tasks

desc 'Run tests'
task default: [:test]

task spec: [:test]

task :test do
  system 'bundle exec rspec'
end
