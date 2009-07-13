#!/usr/bin/env ruby

require 'rubygems'
require 'rake'
require 'spec/rake/spectask'

# task : run specs
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end