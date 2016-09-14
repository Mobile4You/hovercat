$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hovercat/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'hovercat'
  s.version     = Hovercat::VERSION.dup
  s.authors     = ['Leonardo Bernardelli', 'Clayton Pacheco', 'Rofolfo Burla', 'Sandro Mileno']
  s.email       = ['contact-hovercat@m4u.com.br']
  s.homepage    = 'https://github.com/Mobile4You/hovercat'
  s.summary     = 'RabbitMQ connection abstraction with a retry handle.'
  s.description = 'RabbitMQ connection abstraction with a retry handle'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '>= 4.2.5.1', '< 5.0.0.1'
  s.add_dependency 'bunny', '2.5.1'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'

  s.test_files = Dir["spec/**/*"]
end
