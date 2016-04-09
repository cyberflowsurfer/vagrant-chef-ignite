# Vagrent-Ignite

A collection of Chef recipes for provisioning a Vagrent based Linux
development environment using Chef solo. This is primarly an integration
that leverages a lot of existing work.

By default this provisions the following:
  * base
    * set timezone
    * create users: developer and deployer
    * install and configure git
    * install dpkgs
  * Install zsh and oh-my-zsh for configured users
  * Install python
  * Install node.js and npm
  * Install rbenv and ruby
  * Install postgress

**Note:** Some receipes are just wrappers for existing recipes to provide the flexability for future customizations

## Installation
  1. Install Vagrant
  2. Clone this repositry and cd to the directory
  3. Edit Vagrantfile
     * Edit CONFIG_VM_... settings as appropriate
     * Edit CONFIG_USERS as appropriate. Use "openssl passwd -1 'passsword'" to generate user passwords
     * Optionally edit shared folder definitions: CONFIG_SHARED_FOLDERS
     * Optionally edit/add attributes for various recipies (see # Attributes ------)
  4. Note: If you don't want to embed personalization information in the Vagrent file (e.g., ['git']['user']) you can creaate a personalization.json file with the appropriate definitions.

## Usage

Use standard vagrant commands to manage your instance:
  * ```vagrant up``` - Create and provision your instance
  * ```vagrant provision``` - Provision (or reprovision) the instance
  * ```vagrant-ssh``` - SSH to your instance (or use ```vagrant-ssh-config``` to obtain the necessary inforamtion)
  ...


## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History

2016-04-05: Submit initial version

## Credits

  * Node.js
    * https://github.com/redguide/nodejs
    * http://stackoverflow.com/questions/7214474/how-to-keep-up-with-the-latest-versions-of-node-js-in-ubuntu-ppa-compiling

## License

This software is licensed under the Apache 2 license, quoted below.

Copyright 2016 Seth Hawthorne <cyberflowsurfer@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License. You may obtain a copy of
the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations under
the License.
