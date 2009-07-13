require 'rubygems'

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