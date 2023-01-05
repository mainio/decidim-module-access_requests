# frozen_string_literal: true

module Decidim
  module AccessRequests
    module Verification
      module Admin
        # A command to confirm a previous partial authorization.
        # This is just a wrapper class to call the ConfirmUserAuthorization
        # command because we add the email notifications here.
        class ConfirmUserAccessRequest < Decidim::Command
          # Public: Initializes the command.
          #
          # authorization - An Authorization to be confirmed.
          # form - A form object with the verification data to confirm it.
          # session - An active user session
          def initialize(authorization, form, session)
            @authorization = authorization
            @form = form
            @session = session
          end

          # Executes the command. Broadcasts these events:
          #
          # - :ok when everything is valid.
          # - :invalid if the handler wasn't valid and we couldn't proceed.
          #
          # Returns nothing.
          def call
            parent = self

            Decidim::Verifications::ConfirmUserAuthorization.call(authorization, form, session) do
              on(:ok) do
                send_notification
                parent.send(:broadcast, :ok)
              end

              on(:invalid) do
                parent.send(:broadcast, :invalid)
              end

              on(:already_confirmed) do
                parent.send(:broadcast, :invalid)
              end
            end
          end

          private

          attr_reader :authorization, :form, :session

          def send_notification
            Decidim::EventsManager.publish(
              event: "decidim.events.access_requests.confirmed",
              event_class: AccessRequestConfirmedEvent,
              resource: authorization,
              affected_users: [authorization.user],
              extra: {
                user_name: authorization.user.name,
                user_nickname: authorization.user.nickname,
                handler_name: authorization.name
              }
            )
          end
        end
      end
    end
  end
end
