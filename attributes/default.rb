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
default[cookbook_name]['bridge_name'] = 'fan-250'
default[cookbook_name]['authorized_keys'] = ''
default[cookbook_name]['trust_password'] = 'ubuntu'
default[cookbook_name]['lxd_systemd_unit'] = <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=LXD - main daemon
  After=network-online.target openvswitch-switch.service lxcfs.service lxd.socket
  Requires=network-online.target lxcfs.service lxd.socket
  Documentation=man:lxd(1)

  [Service]
  EnvironmentFile=-/etc/environment
  ExecStartPre=/usr/lib/x86_64-linux-gnu/lxc/lxc-apparmor-load
  ExecStart=/usr/bin/lxd --group lxd --logfile=/var/log/lxd/lxd.log
  ExecStartPost=/usr/bin/lxd waitready --timeout=600
  KillMode=process
  TimeoutStartSec=600s
  TimeoutStopSec=30s
  Restart=on-failure
  LimitNOFILE=1048576
  LimitNPROC=infinity
  TasksMax=infinity
  LimitMEMLOCK=infinity

  [Install]
  Also=lxd-containers.service lxd.socket
  EOU
default[cookbook_name]['sauron']['register'] = false 
default[cookbook_name]['sauron']['url'] = 'http://127.0.0.1/container-hosts'
