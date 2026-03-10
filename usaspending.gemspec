# frozen_string_literal: true

require_relative "lib/usaspending/version"

Gem::Specification.new do |spec|
  spec.name = "usaspending-rb"
  spec.version = USAspending::VERSION
  spec.authors = ["Jack Killilea"]
  spec.email = ["xkillilea@gmail.com"]

  spec.summary = "Ruby client for the USAspending.gov v2 API"
  spec.description = <<~DESC
    A Ruby client for the USAspending.gov REST API v2. Access federal award data,
    agency spending, geographic breakdowns, recipient profiles, and more.
    The first Ruby client targeting the current v2 API.
  DESC
  spec.homepage = "https://github.com/xjackk/usaspending-rb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata = {
    "homepage_uri"    => spec.homepage,
    "source_code_uri" => spec.homepage,
    "changelog_uri"   => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "rubygems_mfa_required" => "true",
    "documentation_uri"     => "https://rubydoc.info/gems/usaspending-rb"
  }

  spec.files = Dir.glob("{lib}/**/*") + %w[LICENSE.txt README.md CHANGELOG.md]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "faraday-retry", "~> 2.0"

  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "vcr", "~> 6.2"
  spec.add_development_dependency "webmock", "~> 3.23"
  spec.add_development_dependency "rubocop", "~> 1.65"
  spec.add_development_dependency "rubocop-rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.22"
  spec.add_development_dependency "yard", "~> 0.9"
end
