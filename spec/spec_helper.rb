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

      # Respond to the metadata request with a stubbed request to avoid external
      # HTTP calls.
      # base_path = File.expand_path(File.join(__dir__, ".."))
      stub_request(
        :get,
        "https://auth.tunnistamo-test.fi/idp"
      ).to_return(status: 200, body: "RESPONSE", headers: {})

      # Re-define the password validators due to a bug in the "email included"
      # check which does not work well for domains such as "1.lvh.me" that we are
      # using during tests.
      PasswordValidator.send(:remove_const, :VALIDATION_METHODS)
      PasswordValidator.const_set(
        :VALIDATION_METHODS,
        [
          :password_too_short?,
          :password_too_long?,
          :not_enough_unique_characters?,
          :name_included_in_password?,
          :nickname_included_in_password?,
          # :email_included_in_password?,
          :domain_included_in_password?,
          :password_too_common?,
          :blacklisted?
        ].freeze
      )
    end
  end
end
