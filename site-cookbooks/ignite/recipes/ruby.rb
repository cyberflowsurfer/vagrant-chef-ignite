# Cookbook: Ignite
# Recipie:  ruby
#           Wrapper recipie for installing Ruby
#
# Copyright 2016, Seth Hawthorne <cyperflowsurfer@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require_relative '../libraries/chef_ignite_users'

include_recipe "ruby_build"
include_recipe "rbenv::user"
include_recipe "rbenv::vagrant"

# Create .*rc files
user_installs = node['rbenv']['user_installs'] || []
user_installs.each  do |ui|
  %w(gemrc irbrc railsrc).each do |rc|
    template File.join(Chef::Ignite::Users::user_home(ui['user']),".#{rc}") do
      source "#{rc}.erb"
      owner ui['user']
      group ui['group'] if ui['group']
      mode 00644
    end
  end
end
