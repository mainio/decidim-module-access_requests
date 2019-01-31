# frozen_string_literal: true

module Decidim
  module AccessRequests
    module Verification
      # This is an engine that implements the administration interface for
      # user authorization by access request.
      class AdminEngine < ::Rails::Engine
        isolate_namespace Decidim::AccessRequests::Verification::Admin
        paths["db/migrate"] = nil

        routes do
          resources :pending_authorizations, only: [:index, :update, :destroy]
          resources :granted_authorizations, only: [:index, :new, :create, :destroy]

          root to: "pending_authorizations#index"
        end
      end
    end
  end
end
