module Ringbell
  module Engine
    class RailsConsole
      def self.notify user, obj, options
        Rails.logger.info "#{obj} sends a notification to the #{user}. Options: #{options}"
      end
    end
  end
end