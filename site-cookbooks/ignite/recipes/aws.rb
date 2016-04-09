# Ignite::aws
#   Install AWS utilities
#
#
require_recipie 'python'

bash "Register PPA" do
  code <<-EOH
     sudo pip install awscli --ignore-installed six
  EOH
end
