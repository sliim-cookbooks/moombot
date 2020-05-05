# Cookbook:: moombot
# Recipe:: default
# Copyright:: 2015-2020 Sliim

include_recipe 'moombot::install'
include_recipe 'moombot::plugins'
include_recipe 'moombot::configure'
include_recipe 'moombot::service'
