# Cookbook: Ignite
# File:     metadata.rb
#           Cookbook meta data and dependencies
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
name              "ignite"
maintainer        "Seth Hawthorne"
maintainer_email  "cyberflowsurfer@gmail.com"
license           "Apache 2.0"
description       "Wrapper to simplify provisioning development VMs for a variety of stacks"
version           "0.1.0"

depends           'apt'
#depends           "bashrc"
depends           'dpkg_packages'
depends           'nodejs'
depends           'nginx'
depends           'passenger'
depends           'postgresql'
depends           'python'
depends           'redis'
depends           'ruby_build'
depends           'rbenv'
depends           'timezone-ii'

recipe "ignite",         "Install default development box config"
recipe "ignite::base",   "Installs base system without dev packages"

%w{ debian ubuntu }.each do |os|
  supports os
end
