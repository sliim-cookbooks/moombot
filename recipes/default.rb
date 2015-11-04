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

group 'moombot'

user 'moombot' do
  group 'moombot'
  system true
  shell '/bin/sh'
  home '/opt/moombot'
end

directory '/opt/moombot' do
  owner 'moombot'
  group 'moombot'
  mode '0750'
  recursive true
end

cookbook_file '/opt/moombot/daemon' do
  source 'daemon.rb'
  owner 'moombot'
  group 'moombot'
  mode '0750'
  notifies :restart, 'service[moombot]', :delayed
end

if node['init_package'] == 'systemd'
  cookbook_file '/etc/systemd/system/moombot.service' do
    source 'service-systemd'
    owner 'moombot'
    group 'moombot'
    mode '0644'
  end
else
  cookbook_file '/etc/init.d/moombot' do
    source 'service-init'
    owner 'moombot'
    group 'moombot'
    mode '0755'
  end
end

service 'moombot' do
  action [:enable, :start]
  supports status: true, start: true, stop: true, restart: true
end
