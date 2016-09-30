require 'rubygems'
require 'bundler/setup'

Bundler::GemHelper.install_tasks

desc 'Run tests'
task default: [:test]

desc 'Run tests'
task spec: [:test]

desc 'Run tests'
task(:test) { system 'bundle exec rspec' }
