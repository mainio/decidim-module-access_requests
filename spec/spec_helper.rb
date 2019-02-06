# frozen_string_literal: true

require "decidim/dev"

require "simplecov"
SimpleCov.start "rails"
if ENV["CODECOV"]
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

ENV["ENGINE_ROOT"] = File.dirname(__dir__)

Decidim::Dev.dummy_app_path =
  File.expand_path(File.join(__dir__, "decidim_dummy_app"))

require "decidim/dev/test/base_spec_helper"

RSpec.configure do |config|
  config.before do
    Decidim::Verifications.register_workflow(:ar_verification) do |workflow|
      workflow.engine = Decidim::AccessRequests::Verification::Engine
      workflow.admin_engine = Decidim::AccessRequests::Verification::AdminEngine
    end
  end
end
