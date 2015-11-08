# -*- coding: utf-8 -*-
#
# Cookbook Name:: moombot
# Recipe:: plugins
#
# Copyright 2015, Sliim
#

directory "#{node['moombot']['home']}/plugins" do
  owner node['moombot']['name']
  group node['moombot']['name']
  mode '0750'
end

node['moombot']['cinch']['plugins'].each do |plugin|
  cookbook_file "#{node['moombot']['home']}/plugins/#{plugin}.rb" do
    source "plugins/#{plugin}.rb"
    owner node['moombot']['name']
    group node['moombot']['name']
    mode '0640'
    notifies :restart, "service[#{node['moombot']['name']}]", :delayed
  end
end

service node['moombot']['name'] do
  action :nothing
end
