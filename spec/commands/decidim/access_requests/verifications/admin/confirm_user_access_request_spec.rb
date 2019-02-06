# frozen_string_literal: true

require "spec_helper"

module Decidim
  module AccessRequests
    module Verification
      module Admin
        describe ConfirmUserAccessRequest do
          subject { described_class.new(authorization, form) }

          let(:organization) do
            create(:organization, available_authorizations: [verification_type])
          end

          let(:authorization) do
            create(
              :authorization,
              :pending,
              name: "ar_verification"
            )
          end

          let(:verification_type) { "ar_verification" }

          let(:form) do
            Decidim::AccessRequests::Verification::RequestForm.new(
              handler_handle: verification_type
            ).with_context(current_organization: organization)
          end

          let(:user) { authorization.user }

          context "when confirm access request successfully passes" do
            it "broadcasts ok" do
              expect(Decidim::EventsManager).to receive(:publish).with(
                event: "decidim.events.access_requests.confirmed",
                event_class: Decidim::AccessRequests::AccessRequestConfirmedEvent,
                resource: authorization,
                # affected_users: [authorization.user], # 0.16+
                recipient_ids: [authorization.user.id],
                extra: {
                  user_name: authorization.user.name,
                  user_nickname: authorization.user.nickname,
                  handler_name: authorization.name
                }
              )
              expect { subject.call }.to broadcast(:ok)
            end
          end

          context "when confirm access request does not pass" do
            before do
              expect(form).to receive(:valid?).and_return(false)
            end

            it "broadcasts invalid" do
              expect { subject.call }.to broadcast(:invalid)
            end
          end
        end
      end
    end
  end
end
