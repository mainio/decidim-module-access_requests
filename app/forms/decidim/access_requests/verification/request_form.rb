# frozen_string_literal: true

module Decidim
  module AccessRequests
    module Verification
      # A form object to be used when public users want to get verified by
      # access requests.
      class RequestForm < AuthorizationHandler
        attribute :handler_handle, String

        validates :handler_handle,
                  presence: true,
                  inclusion: {
                    in: proc { |form|
                      form.current_organization.available_authorizations
                    }
                  }

        def handler_name
          handler_handle
        end
      end
    end
  end
end
