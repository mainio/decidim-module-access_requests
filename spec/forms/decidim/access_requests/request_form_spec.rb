# frozen_string_literal: true

require "spec_helper"

module Decidim
  module AccessRequests
    module Verification
      describe RequestForm do
        subject { form }

        let(:organization) do
          create(:organization, available_authorizations: [verification_type])
        end

        let(:verification_type) { "ar_verification" }
        let(:handler_handle) { verification_type }

        let(:params) do
          { handler_handle: handler_handle }
        end

        let(:form) do
          described_class.from_params(params).with_context(
            current_organization: organization
          )
        end

        context "when everything is OK" do
          it { is_expected.to be_valid }
        end

        context "with invalid handler handle" do
          let(:handler_handle) { "unexisting" }

          it { is_expected.to be_invalid }
        end

        describe "#handler_name" do
          it { expect(form.handler_name).to eq(handler_handle) }
        end
      end
    end
  end
end
