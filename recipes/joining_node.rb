#
# Cookbook:: lxc-host
# Recipe:: joining_node
#
# Copyright:: 2018, BaritoLog.
#
#

if node[cookbook_name][:lxd_cluster_address].nil? ||
  node[cookbook_name][:lxd_cluster_certificate].nil?
  Chef::Log.error("Required parameter missing: lxd_cluster_address or lxd_cluster_certificate")
  fail
end

if node[cookbook_name][:custom_ipaddress].nil?
  node_ipaddress = node[:ipaddress]
else
  node_ipaddress = node[cookbook_name][:custom_ipaddress]
end

include_recipe "#{cookbook_name}::install"

template '/etc/default/lxd_preseed.yml' do
  source 'etc/default/joining_node_preseed.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(:lxd_bind_address =>  node_ipaddress,
            :server_name => node.name,
            :network_bridge_name => node[cookbook_name][:network_bridge_name],
            :underlay_subnet => node[cookbook_name][:underlay_subnet],
            :overlay_subnet => node[cookbook_name][:overlay_subnet],
            :lxd_cluster_address => node[cookbook_name][:lxd_cluster_address],
            :lxd_cluster_certificate => node[cookbook_name][:lxd_cluster_certificate],
            :lxd_cluster_password => node[cookbook_name][:lxd_cluster_password],
            :storage_pool_source => node[cookbook_name][:storage_pool_source],
            :storage_pool_name => node[cookbook_name][:storage_pool_name],
            :storage_pool_driver => node[cookbook_name][:storage_pool_driver],
            :ssh_authorized_key => node[cookbook_name][:ssh_authorized_key])
end

execute "wait for LXD to be initialized" do
  command "sleep 10"
end

execute 'lxd init' do
  command "cat /etc/default/lxd_preseed.yml | sudo lxd init --preseed"
end

include_recipe "#{cookbook_name}::optimize"
include_recipe "#{cookbook_name}::sauron_register"
