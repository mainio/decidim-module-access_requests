# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "decidim/access_requests/version"

Gem::Specification.new do |spec|
  spec.name = "decidim-access_requests"
  spec.version = Decidim::AccessRequests.version
  spec.required_ruby_version = ">= 3.0"
  spec.authors = ["Antti Hukkanen"]
  spec.email = ["antti.hukkanen@mainiotech.fi"]

  spec.summary = "Allows admins to add new access request authorizations."
  spec.description = "Access requests allow platform users to request access on specific features of the platform."
  spec.homepage = "https://github.com/mainio/decidim-module-access_requests"
  spec.license = "AGPL-3.0"

  spec.files = Dir[
    "{app,config,lib}/**/*",
    "LICENSE-AGPLv3.txt",
    "Rakefile",
    "README.md"
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "decidim-admin", Decidim::AccessRequests.decidim_version
  spec.add_dependency "decidim-core", Decidim::AccessRequests.decidim_version
  spec.add_dependency "decidim-verifications", Decidim::AccessRequests.decidim_version

  spec.add_development_dependency "decidim-dev", Decidim::AccessRequests.decidim_version
  spec.metadata["rubygems_mfa_required"] = "true"
end
