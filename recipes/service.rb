# -*- coding: utf-8 -*-
#
# Cookbook Name:: moombot
# Recipe:: service
#
# Copyright 2015, Sliim
#

if node['init_package'] == 'systemd'
  template "/etc/systemd/system/#{node['moombot']['name']}.service" do
    source 'service-systemd.erb'
    owner node['moombot']['name']
    group node['moombot']['name']
    mode '0644'
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
    notifies :restart, "service[#{node['moombot']['name']}]", :delayed
  end
else
  template "/etc/init.d/#{node['moombot']['name']}" do
    source 'service-init.erb'
    owner node['moombot']['name']
    group node['moombot']['name']
    mode '0755'
    notifies :restart, "service[#{node['moombot']['name']}]", :delayed
  end
end

service node['moombot']['name'] do
  action :enable
  supports status: true, start: true, stop: true, restart: true
  subscribes :restart,
             "cookbook_file[#{node['moombot']['home']}/daemon]", :delayed
  subscribes :restart,
             "template[#{node['moombot']['home']}/config.rb]", :delayed
end

execute 'systemctl-daemon-reload' do
  action :nothing
  command 'systemctl daemon-reload'
end
