#
# Cookbook:: lxc-host
# Recipe:: default
#
# Copyright:: 2018, BaritoLog.
#
#

package 'ubuntu-fan'

underlay_cidr = node[cookbook_name]['underlay_cidr']
overlay_cidr = node[cookbook_name]['overlay_cidr']
bridge_name = node[cookbook_name]['bridge_name']

service 'networking' do
  action :nothing
end

template "/etc/network/interfaces.d/#{bridge_name}" do
  source 'etc/network/interfaces.d/fan.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables fan_interface: node[cookbook_name]['fan_interface'], overlay_cidr: overlay_cidr, underlay_cidr: underlay_cidr
  notifies :restart, "service[networking]", :immediately
end

sysctl 'vm.max_map_count' do
  value 262144
end

apt_repository 'ubuntu-lxc' do
  uri 'ppa:ubuntu-lxc/lxc-stable'
end

bash 'install lxd' do
  code <<-EOH
    sudo apt-get update
    sudo apt install -y -t xenial-backports lxd lxd-client
  EOH
end

execute 'setup lxd' do
  command "lxd init --auto --network-address 0.0.0.0 --trust-password #{node[cookbook_name]['trust_password']}"
end

template '/etc/default/lxd-profile' do
  source 'etc/default/lxd-profile.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables authorized_keys: node[cookbook_name]['authorized_keys'], bridge_name: node[cookbook_name]['bridge_name']
end

execute 'edit default profile' do
  command 'cat /etc/default/lxd-profile | sudo lxc profile edit default'
end

if node[cookbook_name]['sauron']['register']
  http_request 'register host with sauron' do
    action :post
    url node[cookbook_name]['sauron']['url']
    message ({
      hostname: node['hostname'], 
      ipaddress: node['ipaddress']
    }.to_json)
    headers({
      'Content-Type' => 'application/json'
    })
  end
end