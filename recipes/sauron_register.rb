#
# Cookbook:: lxc-host
# Recipe:: sauron_register
#
# Copyright:: 2018, BaritoLog.
#
#

if node[cookbook_name]['sauron']['register']
  http_request 'register host with sauron' do
    action :post
    url node[cookbook_name]['sauron']['url']
    message ({
      hostname: node.name, 
      ipaddress: node['ipaddress']
    }.to_json)
    headers({
      'Content-Type' => 'application/json'
    })
  end
end
