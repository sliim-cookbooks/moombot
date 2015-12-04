# -*- coding: utf-8 -*-
#
# Cookbook Name:: moombot
# Recipe:: default
#
# Copyright 2015, Sliim
#

include_recipe 'moombot::install'
include_recipe 'moombot::plugins'
include_recipe 'moombot::configure'
include_recipe 'moombot::service'
