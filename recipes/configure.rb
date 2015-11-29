# -*- coding: utf-8 -*-
#
# Cookbook Name:: moombot
# Recipe:: configure
#
# Copyright 2015, Sliim
#

template "#{node['moombot']['home']}/config.rb" do
  source 'config.rb.erb'
  owner node['moombot']['name']
  group node['moombot']['name']
  mode '0640'
end
