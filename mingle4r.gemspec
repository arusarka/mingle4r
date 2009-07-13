require 'rubygems'

spec = Gem::Specification.new do |s|
  s.name = 'mingle4r'
  s.version = '0.0.1'
  s.author = 'asur'
  s.email = 'arusarka@gmail.com'
  s.homepage = 'http://github.com/arusarka/mingle4r/'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Mingle connector'
  s.description = <<-EOS
  This gem provides a wrapper around active resource so that the user can directly use the rest API exposed
  by Mingle without much hassle.It provides a easy way to communicate with mingle. For the library to work you need to
  enable basic authentication (not enabled by default) in Mingle. See below to enable 
  basic authentication in Mingle.

  Enable basic authentication in Mingle
  -------------------------------------

  1) Go to Mingle DataDir

  2) Open YAML file <Mingle DataDir>/config/auth_config.yml

  3) Set 'basic_authentication_enabled' to 'true' (without the quotes) if it is not so

  == FEATURES/PROBLEMS:

  It gives you access to projects in the mingle instance, cards under the project and also
  attachments for a particular card.

  == SYNOPSIS:

  A) Getting all the projects for a particular instance
  --------------------------------------------------

  Suppose you want to connect to the mingle instance hosted at http://localhost:8080 where the
  username is 'testuser' and password is 'password'.

  m_c = Mingle4r::MingleClient.new('http://localhost:8080', 'testuser', 'password')
  projs = m_c.projects

  projs is an array of active resource objects

  B) Getting a particular project
  ----------------------------

  Before you access a particular project you need to set the project id for the mingle client 
  object. You can do that in two ways. Supposing you are trying to access a project with an
  identifier of 'great_mingle_project'

  WARNING : project identifier and project name are different. If you named your project as
  'Great Mingle Project' it's identifier is by default 'great_mingle_project'. To be sure what
  the identifier of a project is you should look at the url in mingle in the particular project
  you are trying to access. It should be something like 'http://localhost:8080/projects/great_mingle_project'

  1) Set at initialize time

  m_c = Mingle4r::MingleClient.new('http://localhost:8080', 'testuser', 'password', 'great_mingle_project')
  m_c.project

  2) Set an attribute later

  m_c = Mingle4r::MingleClient.new('http://localhost:8080', 'testuser', 'password')
  m_c.proj_id = 'great_mingle_project'
  m_c.project

  C) Getting cards for a particular project
  --------------------------------------

  Get a mingle client object initialized as in SECTION B. Then call the cards method.

  m_c = Mingle4r::MingleClient.new('http://localhost:8080', 'testuser', 'password')
  m_c.proj_id = 'great_mingle_project'
  m_c.cards

  cards will be an array of activeresoure objects.

  == REQUIREMENTS:

  1) active_resource gem, it would be automatically taken care of
  during gem install.

  2) Mingle > 2.3

  == INSTALL:

  sudo (not on crappy windows) gem install mingle4r

  EOS
  s.files = Dir['lib/**/*.rb'] + Dir['spec/**/*_spec.rb'] + Dir['test/**/*.rb'] + ['README', 'History.txt']
  s.require_path = 'lib'
  s.extra_rdoc_files = ['README']
  s.add_dependency('activeresource')
end