require 'active_support/concern'

module Monologue
  module ControllerHelpers
    module Auth
      extend ActiveSupport::Concern
      include Monologue::ControllerHelpers::User

      included do
        before_filter :authenticate_user!
      end

      private
      def authenticate_user!
        if monologue_current_user.nil?
          login_url = if Monologue::Config.devise
            main_app.new_user_session_path
          else
            monologue.admin_login_url
          end

          redirect_to login_url, alert: I18n.t("monologue.admin.login.need_auth")
        end
      end
    end
  end
end