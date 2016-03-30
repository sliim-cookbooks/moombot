# -*- coding: utf-8 -*-
#
# Cookbook Name:: moombot
# Attributes:: default
#
# Copyright 2015, Sliim
#

default['moombot']['name'] = 'moombot'
default['moombot']['home'] = "/opt/#{node['moombot']['name']}"

default['moombot']['cinch']['nick'] = 'moombot-dev'
default['moombot']['cinch']['server'] = 'irc.hackint.eu'
default['moombot']['cinch']['port'] = 9999
default['moombot']['cinch']['channels'] = ['#moombot-dev']
default['moombot']['cinch']['primary_channel'] = '#moombot-dev'
default['moombot']['cinch']['ssl']['use'] = true
default['moombot']['cinch']['ssl']['verify'] = false

default['moombot']['loggers']['level'] = 'info'
default['moombot']['loggers']['first_level'] = 'info'

default['moombot']['plugins'] = %w(ping server)

default['moombot']['plugin_server']['bind_address'] = '127.0.0.1'
default['moombot']['plugin_server']['port'] = 7331
