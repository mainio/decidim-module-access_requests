
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "decidim/access_requests/version"

Gem::Specification.new do |spec|
  spec.name          = "decidim-access_requests"
  spec.version       = Decidim::AccessRequests::VERSION
  spec.authors       = ["Antti Hukkanen"]
  spec.email         = ["antti.hukkanen@mainiotech.fi"]

  spec.summary       = "Allows admins to add new access request authorizations."
  spec.description   = "Access requests allow platform users to request access on specific features of the platform."
  spec.homepage      = "https://github.com/mainio/decidim-module-access_requests"
  spec.license       = "AGPL-3.0"

  spec.files = Dir[
    "{app,config,lib}/**/*",
    "LICENSE-AGPLv3.txt",
    "Rakefile",
    "README.md"
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "decidim-admin", Decidim::AccessRequests::DECIDIM_VERSION
  spec.add_dependency "decidim-core", Decidim::AccessRequests::DECIDIM_VERSION

  spec.add_development_dependency "decidim-dev", Decidim::AccessRequests::DECIDIM_VERSION
end
