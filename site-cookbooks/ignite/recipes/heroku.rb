# Ignite:heroku
#   Install heroku tools
#
#   Cite: https://toolbelt.heroku.com/debian
#
bash "Install Heroku toolbelt" do
  code <<-EOH
    wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh
    heroku plugins:install git://github.com/ddollar/heroku-config.git
  EOH
end
