# Cookbook: Ignite
# Recipe:   Dev
#   Install basic development packages
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

package 'git-core'
package 'build-essential'

bash 'Configure git' do
  username = node['users']['developer']['user']
  user username
  # Work around the fact that we don't have a logon shell to set cwd
  # http://tickets.opscode.com/browse/CHEF-2288
  environment (Chef::Ignite::Users.user_env(username))
  code <<-EOC
    git config  --global user.name  "#{node['git']['name']}"
    git config  --global user.email "#{node['git']['email']}"
  EOC
  only_if {"#{node['git']}"}
end
