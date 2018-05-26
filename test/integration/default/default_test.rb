# # encoding: utf-8

# Inspec test for recipe lxc-host::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('ubuntu-fan') do
  it { should be_installed }
end

describe bridge('fan-10') do
  it { should exist }
end

describe command('fanctl show | grep fan') do
  its('stdout') { should eq "fan-10           10.0.2.15/16         250.0.0.0/8          dhcp bridge=fan-10\n" }
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
