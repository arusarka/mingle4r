#!/usr/bin/env ruby

require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'
require 'rake/gempackagetask'
require 'rake/clean'

task :gem => ['gem:build']

namespace :gem do
  desc "Builds the gem"
  task :build => 'pkg' do
    file_name = "#{File.dirname(__FILE__)}/mingle4r.gemspec"
    spec = Gem::Specification.load(file_name)
    Gem::Builder.new(spec).build
    file = FileList["#{File.dirname(__FILE__)}/mingle4r*.gem"]
    mv file.to_a, "#{File.dirname(__FILE__)}/pkg"
  end
end

# task : run specs
RSpec::Core::RakeTask.new do |t|
  if(ENV['test'] && (ENV['test'] != 'all'))
    t.pattern = 'spec/**/' + ENV['test'] + '_spec.rb'
  else  
    t.pattern = 'spec/**/*_spec.rb'
  end
  t.verbose = true
end

desc 'run tests'
task :default => :spec

directory 'pkg'
CLEAN.include 'pkg'