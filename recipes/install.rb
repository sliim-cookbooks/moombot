# -*- coding: utf-8 -*-
#
# Cookbook Name:: moombot
# Recipe:: install
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

cookbook_file "#{node['moombot']['home']}/daemon" do
  source 'daemon.rb'
  owner node['moombot']['name']
  group node['moombot']['name']
  mode '0750'
end
