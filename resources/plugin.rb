# Cookbook:: moombot
# Resource:: plugin
# Copyright:: 2015-2020 Sliim

actions :create, :delete
default_action :create
resource_name :moombot_plugin

attribute :cookbook, kind_of: String, default: 'moombot'
