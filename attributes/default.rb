#
# Cookbook:: lxc-host
# Attribute:: default
#
# Copyright:: 2018, BaritoLog.
#
#

cookbook_name = 'lxc-host'

default[cookbook_name]['lxd_snap_channel'] = '3.0/stable'
# default[cookbook_name]['lxd_cluster_address'] = 
# default[cookbook_name]['lxd_cluster_certificate'] = 
default[cookbook_name]['lxd_cluster_password'] = 'ubuntu'
default[cookbook_name]['network_bridge_name'] = 'fan-250'
default[cookbook_name]['underlay_subnet'] = '10.0.0.0/16'
default[cookbook_name]['overlay_subnet'] = '250.0.0.0/8'
# default[cookbook_name]['storage_pool_source'] =
default[cookbook_name]['storage_pool_name'] = 'local'
default[cookbook_name]['storage_pool_driver'] = 'dir'
default[cookbook_name]['authorized_keys'] = ''

default[cookbook_name]['lxd_systemd_unit'] = <<-EOU.gsub(/^\s+/, '')
  [Unit]
  # Auto-generated, DO NOT EDIT
  Description=Service for snap application lxd.daemon
  Requires=snap-lxd-8028.mount
  Wants=network-online.target
  After=snap-lxd-8028.mount network-online.target
  X-Snappy=yes

  [Service]
  ExecStart=/usr/bin/snap run lxd.daemon
  SyslogIdentifier=lxd.daemon
  Restart=always
  WorkingDirectory=/var/snap/lxd/8028
  ExecStop=/usr/bin/snap run --command=stop lxd.daemon
  ExecReload=/usr/bin/snap run --command=reload lxd.daemon
  TimeoutStopSec=600
  Type=simple
  LimitNOFILE=1048576
  LimitNPROC=infinity
  TasksMax=infinity
  LimitMEMLOCK=infinity

  [Install]
  WantedBy=multi-user.target
  EOU
default[cookbook_name]['sauron']['register'] = false 
default[cookbook_name]['sauron']['url'] = 'http://127.0.0.1/container-hosts'
