#!/usr/bin/env ruby

require 'rubygems'
require 'rake'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

$:.unshift(File.dirname(__FILE__) + "/lib")
require 'mingle4r'

spec = Gem::Specification.new do |s|
  s.name = 'mingle4r'
  s.version = Mingle4r::VERSION
  s.author = Mingle4r::AUTHOR
  s.email = 'arusarka@gmail.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Mingle connector'
  s.files = FileList['lib/**/*.rb', '[A-Z]*', 'spec/**/*'].to_a
  s.require_path = '.'
  s.extra_rdoc_files = ['README']
  s.add_dependency('active_resource')
end

# task : gem, package,repackage, clobber_package
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
end

# task : run tests
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end