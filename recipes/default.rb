# -*- coding: utf-8 -*-
#
# Cookbook Name:: moombot
# Recipe:: default
#
# Copyright 2015, Sliim
#

%w(cinch daemons).each do |pkg|
  gem_package pkg do
    gem_binary '/opt/chef/embedded/bin/gem'
  end
end

group node['moombot']['name']

user node['moombot']['name'] do
  group node['moombot']['name']
  system true
  shell '/bin/sh'
  home node['moombot']['home']
end

directory node['moombot']['home'] do
  owner node['moombot']['name']
  group node['moombot']['name']
  mode '0750'
  recursive true
end

template "#{node['moombot']['home']}/config.rb" do
  source 'config.rb.erb'
  owner node['moombot']['name']
  group node['moombot']['name']
  mode '0640'
end

cookbook_file "#{node['moombot']['home']}/daemon" do
  source 'daemon.rb'
  owner node['moombot']['name']
  group node['moombot']['name']
  mode '0750'
  notifies :restart, "service[#{node['moombot']['name']}]", :delayed
end

if node['init_package'] == 'systemd'
  template "/etc/systemd/system/#{node['moombot']['name']}.service" do
    source 'service-systemd.erb'
    owner node['moombot']['name']
    group node['moombot']['name']
    mode '0644'
  end
else
  template "/etc/init.d/#{node['moombot']['name']}" do
    source 'service-init.erb'
    owner node['moombot']['name']
    group node['moombot']['name']
    mode '0755'
  end
end

service node['moombot']['name'] do
  action [:enable, :start]
  supports status: true, start: true, stop: true, restart: true
end
