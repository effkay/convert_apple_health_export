# frozen_string_literal: true

require_relative "lib/convert_apple_health_export/version"

Gem::Specification.new do |spec|
  spec.name = "convert_apple_health_export"
  spec.version = ConvertAppleHealthExport::VERSION
  spec.authors = ["Felipe Kaufmann"]
  spec.email = ["felipekaufmann@gmail.com"]

  spec.summary = "Extract blood pressure data from Apple Health export XML and convert to a CSV"
  # spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = "https://github.com/effkay/convert_apple_health_export"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/effkay/convert_apple_health_export"
  # spec.metadata["changelog_uri"] = "TBD"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
