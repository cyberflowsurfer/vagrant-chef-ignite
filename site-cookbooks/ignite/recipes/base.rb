# Cookbook: Ignite
# Recipe:   Base
#           Wrapper recipe for base provisioning of apt, users, timezone, and
#           application specific packages
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
include_recipe 'apt'
include_recipe 'timezone-ii::default'
include_recipe 'ignite::base_users'
include_recipe 'ignite::base_dev'
include_recipe 'dpkg_packages'
