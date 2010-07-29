require File.dirname(__FILE__) + '/spec_helper'
require 'rubygems/specification'

describe "gemspec" do
  def spec
    return @spec if @spec
    gemspec_data = File.read(File.dirname(__FILE__) + '/../mingle4r.gemspec')
    @spec = eval(gemspec_data)
  end

  it "should have the name as 'mingle4r'" do
    spec.name.should == 'mingle4r'
  end
  
  it "should have the right list of files" do
    files = ['lib/mingle4r.rb',
      'lib/mingle_resource.rb',

      'lib/mingle4r/common_class_methods.rb',
      'lib/mingle4r/helpers.rb',
      'lib/mingle4r/mingle_client.rb',
      'lib/mingle4r/card_format.rb',

      'lib/mingle4r/api/card.rb',
      'lib/mingle4r/api/card/attachment.rb',
      'lib/mingle4r/api/card/comment.rb',
      'lib/mingle4r/api/card/transition.rb',
      'lib/mingle4r/api/execute_mql.rb',
      'lib/mingle4r/api/murmur.rb',
      'lib/mingle4r/api/project.rb',
      'lib/mingle4r/api/property_definition.rb',
      'lib/mingle4r/api/user.rb',
      'lib/mingle4r/api/wiki.rb',

      'MIT-LICENSE',
      'History.txt',
      'VERSION',
      'README.rdoc',
      'TODO.txt']
      spec_files = spec.files
      files.each { |f| spec_files.should include(f) }
  end
  
  it "should have the right version" do
    spec.version.to_s.should == '0.4.7'
  end
end