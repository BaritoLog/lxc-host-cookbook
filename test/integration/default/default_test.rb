# # encoding: utf-8

# Inspec test for recipe lxc-host::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('ubuntu-fan') do
  it { should be_installed }
end

describe file('/etc/network/interfaces.d/fan250') do
  its('mode') { should cmp '0644' }
end

describe bridge('fan-250') do
  it { should exist }
end

describe command('fanctl show | grep fan') do
  its('stdout') { should eq "fan-250          10.0.2.15/16         250.0.0.0/8          dhcp\n" }
end

describe command('sysctl vm.max_map_count') do
  its('stdout') { should eq "vm.max_map_count = 262144\n" }
end

describe apt('ppa:ubuntu-lxc/lxc-stable') do
  it { should exist }
  it { should be_enabled }
end

describe package('lxd lxd-client') do
  it { should be_installed }
end

describe file('/etc/default/lxd-profile') do
  its('mode') { should cmp '0644' }
end
