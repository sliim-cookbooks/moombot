# -*- coding: utf-8 -*-
#
# Cookbook Name:: moombot
# Provider:: plugin
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

action :create do
  unless node['moombot']['plugin_list'].include? new_resource.name
    node.set['moombot']['plugin_list'] << new_resource.name
  end
  cookbook_file "#{node['moombot']['home']}/plugins/#{new_resource.name}.rb" do
    source "plugins/#{new_resource.name}.rb"
    cookbook new_resource.cookbook
    owner node['moombot']['name']
    group node['moombot']['name']
    mode '0640'
    notifies :create,
             "template[#{node['moombot']['home']}/config.rb]", :delayed
    notifies :restart, "service[#{node['moombot']['name']}]", :delayed
  end

  begin
    include_recipe(
      "#{new_resource.cookbook}::plugin_create_#{new_resource.name}")
  rescue Chef::Exceptions::RecipeNotFound
    Chef::Log.info("No recipe for `#{new_resource.name}` plugin action :create")
  end

  new_resource.updated_by_last_action(true)
end

action :delete do
  if node['moombot']['plugin_list'].include? new_resource.name
    node.set['moombot']['plugin_list'].delete(new_resource.name)
  end

  cookbook_file "#{node['moombot']['home']}/plugins/#{new_resource.name}.rb" do
    action :delete
    notifies :create,
             "template[#{node['moombot']['home']}/config.rb]", :immediately
  end

  begin
    include_recipe(
      "#{new_resource.cookbook}::plugin_delete_#{new_resource.name}")
  rescue Chef::Exceptions::RecipeNotFound
    Chef::Log.info("No recipe for `#{new_resource.name}` plugin action :delete")
  end

  new_resource.updated_by_last_action(true)
end
