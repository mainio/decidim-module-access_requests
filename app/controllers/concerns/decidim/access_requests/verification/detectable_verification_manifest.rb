# frozen_string_literal: true

module Decidim
  module AccessRequests
    module Verification
      module DetectableVerificationManifest
        include ActiveSupport::Concern

        def verification_manifest
          if verification_manifest_handle
            Decidim::Verifications.workflows.to_a.find do |verification|
              verification.name == verification_manifest_handle
            end
          end
        end

        def verification_manifest_handle
          request.path.split("/")[2] if request.path =~ %r{^/admin/}
        end
      end
    end
  end
end
