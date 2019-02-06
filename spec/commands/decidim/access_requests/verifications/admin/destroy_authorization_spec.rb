# frozen_string_literal: true

require "spec_helper"

module Decidim
  module AccessRequests
    module Verification
      module Admin
        describe DestroyAuthorization do
          subject { described_class.new(authorization) }

          let(:organization) do
            create(:organization, available_authorizations: [verification_type])
          end

          let(:verification_type) { "ar_verification" }

          context "when authorization exists" do
            let(:authorization) do
              create(
                :authorization,
                :pending,
                name: "ar_verification"
              )
            end

            it "broadcasts ok and destroys the authorization" do
              expect { subject.call }.to broadcast(:ok)
              expect(authorization.destroyed?).to be(true)
            end
          end

          context "when authorization does not exist" do
            let(:authorization) { nil }

            it "broadcasts invalid" do
              expect { subject.call }.to broadcast(:invalid)
            end
          end
        end
      end
    end
  end
end
