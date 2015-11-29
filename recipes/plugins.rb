# -*- coding: utf-8 -*-
#
# Cookbook Name:: moombot
# Recipe:: plugins
#
# Copyright 2015, Sliim
#

node.set['moombot']['plugin_list'] = []

directory "#{node['moombot']['home']}/plugins" do
  owner node['moombot']['name']
  group node['moombot']['name']
  mode '0750'
end

if node['moombot']['plugins'].is_a? ::Chef::Node::ImmutableArray
  node['moombot']['plugins'].each do |name|
    moombot_plugin name
  end
elsif node['moombot']['plugins'].is_a? ::Chef::Node::ImmutableMash
  node['moombot']['plugins'].each do |cookbook_name, plugins|
    plugins.each do |name|
      moombot_plugin name do
        cookbook cookbook_name
      end
    end
  end
else
  Chef::Log.warn('Cannot determine plugins list, '\
                 'attribute must be an Array or a Hash')
end

service node['moombot']['name'] do
  action :nothing
end
