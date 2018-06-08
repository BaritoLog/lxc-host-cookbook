#
# Cookbook:: lxc-host
# Attribute:: default
#
# Copyright:: 2018, BaritoLog.
#
#

cookbook_name = 'lxc-host'

default[cookbook_name]['fan_interface'] = 'eth0'
default[cookbook_name]['underlay_cidr'] = '10.0.0.0/16'
default[cookbook_name]['overlay_cidr'] = '250.0.0.0/8'
default[cookbook_name]['bridge_name'] = 'fan250'
default[cookbook_name]['authorized_keys'] = ''
default[cookbook_name]['trust_password'] = 'ubuntu'
default[cookbook_name]['sauron']['register'] = false 
default[cookbook_name]['sauron']['url'] = 'http://127.0.0.1/container-hosts'
