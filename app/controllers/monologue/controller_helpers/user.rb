require 'active_support/concern'

module Monologue
  module ControllerHelpers
    module User
      extend ActiveSupport::Concern

      included do
        helper_method :monologue_current_user
      end

      private
      def monologue_current_user
        @monologue_current_user ||= if Monologue::Config.devise
          current_user.class.send(:define_method, "can_delete?") do |user|
            return false if self==user
            return false if user.posts.any?
            true
          end
          current_user
        else
          Monologue::User.find(session[:monologue_user_id]) if session[:monologue_user_id]
        end
      end
    end
  end
end