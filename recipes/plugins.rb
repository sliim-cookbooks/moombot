# -*- coding: utf-8 -*-
#
# Cookbook Name:: moombot
# Recipe:: plugins
#
# Copyright 2015, Sliim
#

include_recipe 'moombot::configure'

directory "#{node['moombot']['home']}/plugins" do
  owner node['moombot']['name']
  group node['moombot']['name']
  mode '0750'
end

if node['moombot']['plugins'].is_a? ::Chef::Node::ImmutableArray
  node.set['moombot']['plugin_list'] = node['moombot']['plugins']
  node['moombot']['plugins'].each do |name|
    moombot_plugin name do
      notifies :create,
               "template[#{node['moombot']['home']}/config.rb]", :delayed
    end
  end
elsif node['moombot']['plugins'].is_a? ::Chef::Node::ImmutableMash
  node.set['moombot']['plugin_list'] =
    node['moombot']['plugins'].map { |_k, v| v }.flatten
  node['moombot']['plugins'].each do |cookbook_name, plugins|
    plugins.each do |name|
      moombot_plugin name do
        cookbook cookbook_name
        notifies :create,
                 "template[#{node['moombot']['home']}/config.rb]", :delayed
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
