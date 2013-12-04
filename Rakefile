#!/usr/bin/env rake

require File.expand_path('../config/application', __FILE__)

PushServer::Application.load_tasks

unless ENV['RAILS_ENV'].to_s == 'production'
  require 'yard'
  require 'yard/rake/yardoc_task'
  require 'flog'
  require 'ci/reporter/rake/rspec'

  desc 'Analyze for code complexity'
  YARD::Rake::YardocTask.new(:yard) do |y|
    y.options = %w(--output-dir yardoc)
  end

  namespace :yardoc do
    desc 'generates yardoc files to yardoc/'
    task :generate => :yard do
      puts 'Yardoc files generated at yardoc/'
    end
  end
end
