# -*- coding: utf-8 -*-
name 'moombot'
maintainer 'Sliim'
maintainer_email 'sliim@mailoo.org'
license 'Apache 2.0'
description 'Manage your IRC Bots with Chef & Cinch'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0'

recipe 'moombot::default', 'Includes all recipes'
recipe 'moombot::install', 'Installs moombot'
recipe 'moombot::service', 'Setup moombot service'
recipe 'moombot::configure', 'Configures moombot'
recipe 'moombot::plugins', 'Configures moombot plugins'

supports 'ubuntu'
supports 'debian'
supports 'centos'

source_url 'https://github.com/sliim-cookbooks/moombot' if
  respond_to?(:source_url)
issues_url 'https://github.com/sliim-cookbooks/moombot/issues' if
  respond_to?(:issues_url)
