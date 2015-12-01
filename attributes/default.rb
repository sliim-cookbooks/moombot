# -*- coding: utf-8 -*-
#
# Cookbook Name:: moombot
# Attributes:: default
#
# Copyright 2015, Sliim
#

default['moombot']['name'] = 'moombot'
default['moombot']['home'] = "/opt/#{node['moombot']['name']}"

default['moombot']['plugins'] = %w(ping server)
default['moombot']['plugin_list'] = []

default['moombot']['server']['bind_address'] = '127.0.0.1'
default['moombot']['server']['port'] = 7331

default['moombot']['cinch']['nick'] = 'moombot-dev'
default['moombot']['cinch']['server'] = 'irc.hackint.eu'
default['moombot']['cinch']['port'] = 9999
default['moombot']['cinch']['channels'] = ['#moombot-dev']
default['moombot']['cinch']['primary_channel'] = '#moombot-dev'
default['moombot']['cinch']['ssl']['use'] = true
default['moombot']['cinch']['ssl']['verify'] = false
