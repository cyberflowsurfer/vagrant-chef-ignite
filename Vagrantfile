# -*- mode: ruby -*-
# Ignite::Vagrantfile
#   Vagrant configuration file for creating a VM and provisioning it
#   using Chef Solo. Customize network and other settings as appropriate
#
# Cite: https://gorails.com/guides/using-vagrant-for-rails-development

# Configuration Parameters ---------------------------------------------------
CONFIG_VM_NAME     = 'ignite-dev1'
CONFIG_VM_HOSTNAME = 'localhost'
CONFIG_VM_IP       = '192.168.20.48'
CONFIG_VM_PORTS    = [
                       [80,8080],     #HTTP
                       [442, 8081],   #SSH
                       [3000,3000],   #Rails
                       [5432, 5432],  #Postgress
                       [5555, 5555]   #Node app
                     ]

CONFIG_PERSONALIZATION_FILE = 'personalizations.json'

CONFIG_USERS = {
    'deployer' => {
      'group'     => 'deployers',
      'user'      => 'deployer',
      'password'  =>'$1$WYbdYnNS$UmtYOIwfa2bFIEjE1g2ve.', # openssl passwd -1 "passsword"
      'has_sudo'  => true,
    },
    'developer'   => {
      'group'     =>'developers',
      'user'      =>'developer',
      'password'  =>'$1$rhOMXo1V$RxIw5d65vrIsOGZ74Rm7D/', # openssl passwd -1 "passsword"
      'shell'     => '/bin/zsh',
      'oh-my-zsh' => {
        'plugins' =>   {
                         'git'   => 'https://raw.githubusercontcd /g/sysent.com/robbyrussell/oh-my-zsh/master/plugins/git/git.plugin.zsh',
                         'rbenv' => 'https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/plugins/rbenv/rbenv.plugin.zsh'
                       },
        'themes'  =>   {
                          'bullet-train' => 'https://raw.githubusercontent.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme'
                       },
        'theme'   => 'bullet-train'
      }
    },
    'database' => {
      'group'     => 'developers',
      'user'      => 'postgres',
      'password'  =>'$1$rhOMXo1V$RxIw5d65vrIsOGZ74Rm7D', # openssl passwd -1 "passsword"
      'has_sudo'  => false,
    },
}

CONFIG_SHARED_FOLDERS = [
                          ['./shared/deployer', "/home/#{CONFIG_USERS['deployer']['user']}/shared" ],
                          ['./shared/developer',"/home/#{CONFIG_USERS['developer']['user']}/shared" ],
                          ['./shared',          "/home/vagrant/shared" ]
                        ]


# Vagrant --------------------------------------------------------------------
Vagrant.configure("2") do |config|
  # Use Ubuntu 14.04 Trusty Tahr 64-bit as our operating system
  config.vm.box = "ubuntu/trusty64"

  # Configurate the virtual machine to use 2GB of RAM
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  # Configure VM -------------------------------------------------------------
  config.vm.define CONFIG_VM_NAME do |machine|
    machine.vm.network 'private_network', ip: CONFIG_VM_IP
    machine.vm.hostname = CONFIG_VM_HOSTNAME
    CONFIG_VM_PORTS.each do |port|
      machine.vm.network 'forwarded_port', :guest => port[0], :host => port[1], :auto_correct => true
    end

    CONFIG_SHARED_FOLDERS.each do |dir|
      config.vm.synced_folder dir[0], dir[1], nfs: true
    end

    machine.vm.box = 'ubuntu/trusty64'
  end

  config.ssh.forward_agent = true

  # Provision using Chef Solo ------------------------------------------------
  config.vm.provision :chef_solo do |chef|
#   chef.arguments = '-l debug'
    chef.cookbooks_path    = ['cookbooks', 'site-cookbooks']

    # Attributes --------------------------------------------------------------
    chef.json = {}
    # Ignite::base
    chef.json['users'] = CONFIG_USERS
    chef.json['dpkg_packages'] = {
      'pkgs' =>  {
        'imagemagick' => {'action' => 'install' },
        'htop'        => {'action' => 'install' },
        'tmux'        => {'action' => 'install'}
      }
    }
    chef.json['tz'] = 'America/Los_Angeles'
    chef.json['git'] = {
      'name'  => "Wile E Coyote",
      'email' => 'WileECoyote@acme.com'
    }
    chef.json['python'] = {
 #    'version' => '2.7.5'
    }
    chef.json[:nginx] = {
      'version'    => '1.4.1',
      'log_dir'    => "/var/log/nginx",
      'binary'     => "/opt/nginx-1.4.1/sbin",
      'user'       => CONFIG_USERS['developer']['user'],
      'init_style' => "init",

      user:                 "vagrant",
      client_max_body_size: "2m",
      worker_processes:     "auto",
      worker_connections:   768,
      repository:           "ppa",
      site: {
        host:           "vagrant-machine",
        upstream_ports: ["3000"],
        ip:             "0.0.0.0",
        listen:        "80"
      }
    }
    chef.json['nodejs'] = {
      "npm_packages" => [
        {
          "name" => "express"
        },
        {
          "name"    => "async",
          "version" => "0.6.2"
        }
      ]
    }
    chef.json['postgresql'] = {
      'shared_buffers' =>  "256MB", # 1/4 of total memory is recommended
      'shared_preload_libraries' => "pg_stat_statements",
      'password' => {
         'postgres' =>  'postgres'
      },
      'users' => [
        {
          'username'  => CONFIG_USERS['deployer']['user'],
          'password'  => "123456",
          'superuser' => true,
          'login'     => true
        },
        {
          'username'  => CONFIG_USERS['developer']['user'],
          'password'  => "123456",
          'superuser' => false,
          'login'     => true
        }
      ]
    }
    chef.json['rbenv'] = {
      'user_installs' => [{
        'user'   => CONFIG_USERS['developer']['user'],
        'group'  => CONFIG_USERS['developer']['group'],
        'rubies' => ["2.2.1"],
        'global' => "2.2.1",
        'gems' => {
          "2.2.1" => [
            { 'name' => "bundler" }
          ]
        }
      }]
    }
    # Override any personalized attributes -----------------------------------
    if File.exists?(CONFIG_PERSONALIZATION_FILE)
      require 'json'
      chef.json = chef.json.merge(JSON.parse(File.read(CONFIG_PERSONALIZATION_FILE)))
    end

    # Recipes -----------------------------------------------------------------
    chef.add_recipe 'ignite::base'
    chef.add_recipe 'ignite::zsh'
    chef.add_recipe 'ignite::python'
    chef.add_recipe 'ignite::node_js'
    chef.add_recipe 'ignite::ruby'
    chef.add_recipe 'ignite::postgresql'
#    chef.add_recipe 'ignite::nginx'
#   chef.add_recipe 'ignite::redis'

  end
end
