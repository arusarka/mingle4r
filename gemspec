require 'rubygems'

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

if $0 == __FILE__ 
  Gem::manage_gems 
  Gem::Builder.new(spec).build 
end