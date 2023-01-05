# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

# Inside the development app, the relative require has to be one level up, as
# the Gemfile is copied to the development_app folder (almost) as is.
base_path = ""
base_path = "../" if File.basename(__dir__) == "development_app"
require_relative "#{base_path}lib/decidim/access_requests/version"

DECIDIM_VERSION = Decidim::AccessRequests.decidim_version
# DECIDIM_VERSION = { github: "decidim/decidim", branch: "develop" }

gem "decidim", DECIDIM_VERSION
gem "decidim-access_requests", path: "."

gem "bootsnap", "~> 1.4"
gem "puma", ">= 5.0.0"
gem "uglifier", "~> 4.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
  gem "rubocop-faker"
  gem "rubocop-performance", "~> 1.6.0"
end

group :development do
  gem "faker", "~> 3.1"
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "spring", "~> 4.1"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.2"
end

group :test do
  gem "codecov", require: false
end

# Remediate CVE-2019-5420
gem "railties", ">= 5.2.2.1"
