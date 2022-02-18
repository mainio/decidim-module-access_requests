# frozen_string_literal: true

module Decidim
  module AccessRequests
    module Verification
      # This is an engine that performs user authorization.
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::AccessRequests::Verification
        paths["db/migrate"] = nil

        routes do
          resource :authorizations, only: [:new, :create, :edit], as: :authorization do
            get :renew, on: :collection
          end

          root to: "authorizations#new"
        end

        def load_seed
          # Enable the `:access_requests` authorization
          org = Decidim::Organization.first
          org.available_authorizations << :access_requests
          org.save!
        end
      end
    end
  end
end
