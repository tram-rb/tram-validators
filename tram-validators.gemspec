Gem::Specification.new do |gem|
  gem.name        = "tram-validators"
  gem.version     = "0.0.1"
  gem.author      = "Andrew Kozin (nepalez)"
  gem.email       = "andrew.kozin@gmail.com"
  gem.homepage    = "https://github.com/tram-rb/tram-validators"
  gem.summary     = "Collection of validators for Rails projects"
  gem.license     = "MIT"
  gem.description = "The collection supports composability of standalone" \
                    " policy objects, forms etc."

  gem.files            = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files       = gem.files.grep(/^spec/)
  gem.extra_rdoc_files = Dir["README.md", "LICENSE", "CHANGELOG.md"]

  gem.required_ruby_version = ">= 2.3"

  gem.add_runtime_dependency "rails", "~> 5.0"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "rubocop", ">= 0.44"
end
