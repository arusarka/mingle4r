#!/usr/bin/env ruby

require 'rubygems'
require 'rake'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

spec = Gem::Specification.new do |s|
  s.name = 'mingle4r'
  s.version = '0.0.1'
  s.author = 'asur'
  s.email = 'arusarka@gmail.com'
  s.homepage = 'http://github.com/arusarka/mingle4r/'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Mingle connector'
  s.files = Dir['lib/**/*.rb'] + Dir['spec/**/*_spec.rb'] + Dir['test/**/*.rb'] + ['README', 'History.txt']
  s.require_path = 'lib'
  s.extra_rdoc_files = ['README']
  s.add_dependency('activeresource')
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