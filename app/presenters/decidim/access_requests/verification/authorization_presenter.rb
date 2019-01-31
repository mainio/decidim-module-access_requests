
# frozen_string_literal: true

module Decidim
  module AccessRequests
    module Verification
      #
      # Decorator for access request authorizations.
      #
      class AuthorizationPresenter < SimpleDelegator
        def self.for_collection(authorizations)
          authorizations.map { |authorization| new(authorization) }
        end
      end
    end
  end
end
