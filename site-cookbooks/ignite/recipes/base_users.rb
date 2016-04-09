# Cookbook: Ignite
# Recipe:   users
#           Provisions users and groups based on defined attributes
#             'users' {
#                username => {
#                  'user'         => username
#                  'password'     =>
#                  ['has_sudo']   => true | false
#                  [ 'shell'  ]   =>
#                }
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
#
# create groups
node['users'].values.each do |user|
  group user['group']
end

# create each user and add to the group
node['users'].values.each do |user|
  user user['user'] do
    gid user['group']
    home Chef::Ignite::Users.user_home(user['user'])
    password user['password'] if user['password']
    shell user['shell'] || "/bin/bash"
    supports manage_home: true
  end
end

node['users'].values.each do |user|
  # Surprised the preceding is not setting the ownerhip
  # http://stackoverflow.com/questions/14076867/change-the-default-user-and-group-from-root-to-something-attribute-driven-in-che
  directory Chef::Ignite::Users.user_home(user['user']) do
    owner user['user']
    group user['group']
    mode 00755
  end
end

# Grant sudo privileges
node['users'].values.each do |user|
  if user['has_sudo']
    bash "Grant sudo priviliges to #{user['user']}" do
      code <<-EOH
        sed -i '/%#{user['group']}.*/d' /etc/sudoers
        echo '%#{user['group']} ALL=(ALL) ALL' >> /etc/sudoers
      EOH
      Chef::Log.debug("DEBUG: granted sudo to #{user['user']}")
      not_if "grep -xq '%#{user['group']} ALL=(ALL) ALL' /etc/sudoers"
    end
  end
end
