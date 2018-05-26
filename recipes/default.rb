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

execute 'setup fan network' do
  command "sudo fanctl up -u #{underlay_cidr} -o #{overlay_cidr} --bridge=#{bridge_name} --dhcp"
  not_if 'fanctl show | grep fan'
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
  command "lxd init --auto --network-address #{node['ipaddress']} --trust-password #{node[cookbook_name]['trust_password']}"
end

template '/etc/default/lxd-profile' do
  source 'etc/default/lxd-profile.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables content: YAML::dump(node[cookbook_name]['default_profile'])
end

execute 'edit default profile' do
  command 'cat /etc/default/lxd_profile | sudo lxc profile edit default'
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