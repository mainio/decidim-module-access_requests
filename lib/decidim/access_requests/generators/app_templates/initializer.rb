# frozen_string_literal: true

Decidim::Verifications.register_workflow(:access_requests) do |workflow|
  workflow.engine = Decidim::AccessRequests::Verification::Engine
  workflow.admin_engine = Decidim::AccessRequests::Verification::AdminEngine
end
