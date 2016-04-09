# Cookbook: Ignite
# Recipe:   Node_js
#           Intalls nodejs and npm from nodesource PPA
#
#           Note: Had trouple with the standard recipie installing old versions.
#                 Perhaps "my bad" but working around it for now
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
# Ref: https://github.com/redguide/nodejs
#      http://stackoverflow.com/questions/7214474/how-to-keep-up-with-the-latest-versions-of-node-js-in-ubuntu-ppa-compiling
#      https://github.com/npm/npm/wiki/Troubleshooting#try-the-latest-stable-version-of-npm
#      https://github.com/npm/npm/issues/7308

bash "Configure node repo" do
  code "curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -"
end

package 'nodejs'

bash "Upgrade npm" do
  code "npm -g install npm@latest"
end

include_recipe 'nodejs::npm_packages'
