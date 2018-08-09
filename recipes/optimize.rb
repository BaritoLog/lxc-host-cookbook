#
# Cookbook:: lxc-host
# Recipe:: optimize
#
# Copyright:: 2018, BaritoLog.
#
#

sysctl 'vm.max_map_count' do
  value 262144
end

systemd_unit 'snap.lxd.daemon.service' do
  content node[cookbook_name]['lxd_systemd_unit']
  action [:create, :restart]
end
