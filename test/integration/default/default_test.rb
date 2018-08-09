# # encoding: utf-8

# Inspec test for recipe lxc-host::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe bridge('fan-250') do
  it { should exist }
end

describe file('/etc/default/first_node_preseed.erb') do
  its('mode') { should cmp '0644' }
end

describe command('sysctl vm.max_map_count') do
  its('stdout') { should eq "vm.max_map_count = 262144\n" }
end
