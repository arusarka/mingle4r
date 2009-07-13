#!/usr/bin/env ruby

require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require 'rake/gempackagetask'

namespace :gem do
  desc "Builds the gem"
  task :build do
    file_name = "#{File.dirname(__FILE__)}/mingle4r.gemspec"
    spec = Gem::Specification.load(file_name)
    Gem::Builder.new(spec).build
    file = FileList["#{File.dirname(__FILE__)}/mingle4r*.gem"]
    mv file.to_a, "#{File.dirname(__FILE__)}/pkg"
  end
end

# task : run specs
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end