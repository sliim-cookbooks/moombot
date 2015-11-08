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

include_recipe 'moombot::service'
include_recipe 'moombot::plugins'

template "#{node['moombot']['home']}/config.rb" do
  source 'config.rb.erb'
  owner node['moombot']['name']
  group node['moombot']['name']
  mode '0640'
  notifies :restart, "service[#{node['moombot']['name']}]", :delayed
end

cookbook_file "#{node['moombot']['home']}/daemon" do
  source 'daemon.rb'
  owner node['moombot']['name']
  group node['moombot']['name']
  mode '0750'
  notifies :restart, "service[#{node['moombot']['name']}]", :delayed
end
