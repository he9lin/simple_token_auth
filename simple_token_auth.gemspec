$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "simple_token_auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "simple_token_auth"
  s.version     = SimpleTokenAuth::VERSION
  s.authors     = ["Lin He"]
  s.email       = ["he9lin@gmail.com"]
  s.homepage    = "https://bitbucket.org/he9lin/simple_token_auth"
  s.summary     = "Simple and safe token authentication library that uses Rails' `authenticate_or_request_with_http_token` method
"
  s.description = "Simple and safe token authentication library that uses Rails' `authenticate_or_request_with_http_token` method
"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.6"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "timecop"
end
