# frozen_string_literal: true

module Decidim
  module AccessRequests
    module Verification
      # This is an engine that performs user authorization.
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::AccessRequests::Verification
        paths["db/migrate"] = nil

        routes do
          resource :authorizations, only: [:new, :create, :edit], as: :authorization

          root to: "authorizations#new"
        end

        initializer "decidim_access_requests.assets" do |app|
          app.config.assets.precompile += %w(decidim_access_requests_manifest.css
                                             decidim/access_requests/verification.scss)
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
