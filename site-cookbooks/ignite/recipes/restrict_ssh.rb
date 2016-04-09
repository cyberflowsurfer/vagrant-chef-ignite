# Cite: http://vladigleba.com/blog/2014/08/12/provisioning-a-rails-server-using-chef-part-2-writing-the-recipes/
#
# tell chef about ssh service
service 'ssh' do
  provider Chef::Provider::Service::Upstart
  supports [:status, :restart]
end

# modify port
bash "modify port" do
  code <<-EOH
    sed -i '/Port.*/d' /etc/ssh/sshd_config
    echo 'Port #{node['port']}' >> /etc/ssh/sshd_config
  EOH
  notifies :restart, "service[ssh]", :delayed
  not_if "grep -xq 'Port #{node['port']}' /etc/ssh/sshd_config"
end

# disable root login
bash "disable root login" do
  code <<-EOH
    sed -i '/PermitRootLogin.*/d' /etc/ssh/sshd_config
    echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
  EOH
  notifies :restart, "service[ssh]", :delayed
  not_if "grep -xq 'PermitRootLogin no' /etc/ssh/sshd_config"
end

# restrict login only to created user
bash "restrict login only to created user" do
  code <<-EOH
    sed -i '/AllowUsers.*/d' /etc/ssh/sshd_config
    echo 'AllowUsers #{node['user']['name']}' >> /etc/ssh/sshd_config
  EOH
  notifies :restart, "service[ssh]", :delayed
  not_if "grep -xq 'AllowUsers #{node['user']['name']}' /etc/ssh/sshd_config"
end

# disable dns
bash "disable dns" do
  code <<-EOH
    sed -i '/UseDNS.*/d' /etc/ssh/sshd_config
    echo 'UseDNS no' >> /etc/ssh/sshd_config
  EOH
  notifies :restart, "service[ssh]", :delayed
  not_if "grep -xq 'UseDNS no' /etc/ssh/sshd_config"
end
