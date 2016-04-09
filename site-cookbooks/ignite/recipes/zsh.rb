# Cookbook: Ignite
# Recipe:   Zsh
#           Install ZSH and oh-my-zsh for users that have their shell set to
#           zsh. User resource attributres
#             'users' => {
#                username => {
#                   ...
#                   'osh-my-zsh' => {
#                      'plugins' =>  {
#                        plugin-name => uri
#                        ...
#                      },
#                      'themes' =>  [
#                        uri
#                        ...
#                      ],
#                      'aliases' =>  {
#                         alias: cmd
#                         ...
#                      },
#                      'theme' => theme
#                   }
#
#           Adapted from https://github.com/arlimus/chef-zsh/blob/master/recipes/default.rb
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
require_relative "../libraries/chef_ignite_users"

package 'zsh'
package 'git-core'

CHMOD_MODE  = 00644
OMZ_GIT_URI = 'https://github.com/robbyrussell/oh-my-zsh.git'

node['users'].values.each do |user|
  if user['shell'] =~ /zsh$/
    user_home   = Chef::Ignite::Users::user_home(user['user'])
    omz_home    = File.join(user_home, '.oh-my-zsh')
    omz_atts    = user['oh-my-zsh']
    omz_atts['themes']  ||= {}
    omz_atts['plugins'] ||= {}

    # Install oh-my-zsh
    execute "git clone #{OMZ_GIT_URI} #{omz_home} && chown -R #{user[:user]}:#{user[:group]} #{omz_home}" unless File.exists? omz_home

    # Install themes
    omz_atts['themes'].each do |theme, uri|
      remote_file File.join(omz_home, 'themes', theme) + '.zsh-theme' do
        source uri
        owner user[:user]
        group user[:group]
        mode CHMOD_MODE
      end
    end

    # Install plug-ins
    omz_atts['plugins'].each do |plugin, uri|
      plugin_path = File.join(omz_home, 'plugins', plugin)
      directory plugin_path do
        owner user[:user]
        group user[:group]
        mode CHMOD_MODE
      end
      remote_file plugin_path do
        source uri
        owner user[:user]
        group user[:group]
        mode CHMOD_MODE
        not_if {::File.exists? plugin_path}
      end
    end

    # Create .zshrc
    template File.join(user_home,'.zshrc') do
      source "zshrc.erb"
      owner user[:user]
      group user[:group]
      mode CHMOD_MODE

      variables({
        :theme   => omz_atts['theme']  || 'robbyrussell',
        :plugins => omz_atts['plugins'].keys.join(''),
        :aliases => omz_atts['aliases'] || {}
      })
    end

    # bullet-train theme depends on powerline fonts
    if omz_atts['themes'].keys.include?('bullet-train')
      bash "Install operline fonts" do
        code "curl -sL https://raw.githubusercontent.com/powerline/fonts/master/install.sh | bash -"
      end
    end

  end
end
