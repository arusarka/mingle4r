Gem::Specification.new do |s|
  s.name = 'mingle4r'
  s.version = '0.2.7'
  s.author = 'asur'
  s.email = 'arusarka@gmail.com'
  s.homepage = 'http://github.com/arusarka/mingle4r/'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Mingle connector using active resource'
  s.description = <<-EOS
  A connector wrapper for connecting to Mingle(http://studios.thoughtworks.com/mingle-agile-project-management).
  It uses active resource to handle the restful connections to Mingle. Makes the job of connecting to Mingle a 
  lot easier. Also since it uses lazy evaluation, resources are fetched only when they are requested.
  EOS
  s.files = ['lib/mingle4r/card.rb',
             'lib/mingle4r/card/attachment.rb',
             'lib/mingle4r/common_class_methods.rb',
             'lib/mingle4r/common_dyn_class_instance_methods.rb',
             'lib/mingle4r/helpers.rb',
             'lib/mingle4r/mingle_client.rb',
             'lib/mingle4r/project.rb',
             'lib/mingle4r/property_definition.rb',
             'lib/mingle4r/user.rb',
             'lib/mingle4r/version.rb',
             'lib/mingle4r/wiki.rb',
             'lib/mingle4r.rb',
             'lib/mingle_resource.rb',
             'spec/mingle4r/card/card_spec.rb',
             'spec/mingle4r/card_spec.rb',
             'spec/mingle4r/common_class_methods_spec.rb',
             'spec/mingle4r/helpers_spec.rb',
             'spec/mingle4r/project_spec.rb',
             'spec/mingle4r/property_definition_spec.rb',
             'spec/mingle4r/version_spec.rb',
             'spec/mingle4r/wiki_spec.rb',
             'spec/mingle4r_spec.rb',
             'spec/spec_helper.rb',
             'test/integration/test.rb',
             'test/integration/test_adding_comment.rb',
             'test/integration/test_card_filter.rb',
             'test/integration/test_card_transition.rb',
             'test/integration/test_getting_users.rb',
             'test_uploading_attachment.rb',
             'test/integration/test_wiki.rb',
             'MIT-LICENSE',
             'Rakefile',
             'README',
             'TODO']
  s.require_path = 'lib'
  s.extra_rdoc_files = ['README']
  s.add_dependency('activeresource')
end