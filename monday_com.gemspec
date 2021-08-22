# frozen_string_literal: true

require_relative "lib/monday_com/version"

Gem::Specification.new do |spec|
  spec.name          = "monday_com"
  spec.version       = MondayCom::VERSION
  spec.authors       = ["Ivan Reyes"]
  spec.email         = ["ivanwilf@hotmail.com"]

  spec.summary       = "Monday.com assigend tasks."
  spec.description   = "A simple tool that enlist all of the assigned tasks on monday.com."
  spec.homepage      = "https://github.com/IvanReyesO7"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/IvanReyesO7/monday_com"
  spec.metadata["changelog_uri"] = "https://github.com/IvanReyesO7/monday_com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Added development dependencies as indicated here
  # https://levelup.gitconnected.com/building-a-ruby-cli-gem-from-scratch-fca59acda169

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  
  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
