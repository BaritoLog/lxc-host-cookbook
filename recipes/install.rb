#
# Cookbook:: lxc-host
# Recipe:: install
#
# Copyright:: 2018, BaritoLog.
#
#

apt_update

package 'zfsutils-linux'

execute 'remove default lxd' do
  command "sudo apt-get purge lxd* -y"
end

execute 'install lxd using snap' do
  command "sudo snap install lxd --channel=#{node[cookbook_name]['lxd_snap_channel']}"
end
