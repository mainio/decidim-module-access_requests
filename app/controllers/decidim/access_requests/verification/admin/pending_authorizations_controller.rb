# frozen_string_literal: true

module Decidim
  module AccessRequests
    module Verification
      module Admin
        class PendingAuthorizationsController < Decidim::Admin::ApplicationController
          include DetectableVerificationManifest

          layout "decidim/admin/users"

          def index
            enforce_permission_to :index, :authorization

            @pending_authorizations = AuthorizationPresenter.for_collection(
              pending_authorizations
            )
          end

          def update
            enforce_permission_to :edit, :authorization, authorization: authorization

            @form = RequestForm.new(
              handler_handle: verification_manifest.name
            ).with_context(current_organization: current_organization)

            ConfirmUserAccessRequest.call(authorization, @form) do
              on(:ok) do
                flash[:notice] = t("pending_authorizations.update.success", scope: "decidim.access_requests.verification.admin")
                redirect_to pending_authorizations_path
              end

              on(:invalid) do
                flash.now[:alert] = t("pending_authorizations.update.error", scope: "decidim.access_requests.verification.admin")
                redirect_to pending_authorizations_path
              end
            end
          end

          def destroy
            enforce_permission_to :destroy, :authorization, authorization: authorization

            DestroyAuthorization.call(authorization) do
              on(:ok) do
                flash[:notice] = t("pending_authorizations.destroy.success", scope: "decidim.access_requests.verification.admin")
                redirect_to pending_authorizations_path
              end

              on(:invalid) do
                flash.now[:alert] = t("pending_authorizations.destroy.error", scope: "decidim.access_requests.verification.admin")
                redirect_to pending_authorizations_path
              end
            end
          end

          private

          def pending_authorizations
            Decidim::Verifications::Authorizations.new(
              organization: current_organization,
              name: verification_manifest.name,
              granted: false
            )
          end

          def authorization
            @authorization ||= Authorization.find_by(
              id: params[:id],
              name: verification_manifest.name
            )
          end
        end
      end
    end
  end
end
