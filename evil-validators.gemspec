Gem::Specification.new do |gem|
  gem.name     = "evil-validators"
  gem.version  = "0.0.1"
  gem.author   = "Andrew Kozin (nepalez)"
  gem.email    = "andrew.kozin@gmail.com"
  gem.homepage = "https://github.com/evilmartians/evil-validators"
  gem.summary  = "Collection of validators for Rails projects"
  gem.license  = "MIT"

  gem.files            = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files       = gem.files.grep(/^spec/)
  gem.extra_rdoc_files = Dir["README.md", "LICENSE", "CHANGELOG.md"]

  gem.required_ruby_version = ">= 2.3"

  gem.add_runtime_dependency "rails", "~> 5.0"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "rubocop", ">= 0.44"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "pry-byebug"
  gem.add_development_dependency "rspec-its"
end
