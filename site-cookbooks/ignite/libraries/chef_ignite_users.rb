# Chef::Users
#   User management methods
#
class Chef
  module Ignite
    module Users

      # Handle platform differences in user home directory naming
      def self.user_home(user)
        begin
          Dir.home(user)
        rescue ArgumentError   # Thrown if the user does not exit
          #TODO: Add logic for other platforms
          "/home/#{user}"
        end
      end

      # Return env hash for invoking commands that require an 'interactive' shell
      # See:  http://tickets.opscode.com/browse/CHEF-2288
      def self.user_env(username)
        {'HOME' => user_home(username), 'USER' => "#{username}"}
      end
    end
  end
end
