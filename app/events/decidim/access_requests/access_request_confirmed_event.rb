# frozen-string_literal: true

module Decidim
  module AccessRequests
    class AccessRequestConfirmedEvent < Decidim::Events::SimpleEvent
      delegate :url_helpers, to: "Decidim::Core::Engine.routes"

      i18n_attributes :verification_name

      def resource_url
        url_helpers.profile_url(
          user_nickname,
          host: user.organization.host
        )
      end

      def resource_path
        url_helpers.profile_path(user_nickname)
      end

      def verification_name
        handler_name = extra["handler_name"]
        I18n.t("#{handler_name}.name", scope: "decidim.authorization_handlers")
      end

      def user_nickname
        extra["user_nickname"]
      end
    end
  end
end
