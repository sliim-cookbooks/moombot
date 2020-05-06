# Cookbook:: moombot
# Resource:: plugin
# Copyright:: 2015-2020 Sliim

resource_name :moombot_plugin
provides :moombot_plugin
default_action :create

property :cookbook, String, default: 'moombot'

action :create do
  unless node['moombot']['plugin_list'].include? new_resource.name
    node.override['moombot']['plugin_list'] << new_resource.name
  end
  cookbook_file "#{node['moombot']['home']}/plugins/#{new_resource.name}.rb" do
    source "plugins/#{new_resource.name}.rb"
    cookbook new_resource.cookbook
    owner node['moombot']['name']
    group node['moombot']['name']
    mode '0640'
    notifies :create, "template[#{node['moombot']['home']}/config.rb]", :immediately
  end

  begin
    include_recipe(
      "#{new_resource.cookbook}::plugin_create_#{new_resource.name}")
  rescue Chef::Exceptions::RecipeNotFound
    Chef::Log.info("No recipe for `#{new_resource.name}` plugin action :create")
  end
end

action :delete do
  if node['moombot']['plugin_list'].include? new_resource.name
    node.override['moombot']['plugin_list'].delete(new_resource.name)
  end

  cookbook_file "#{node['moombot']['home']}/plugins/#{new_resource.name}.rb" do
    action :delete
    notifies :create, "template[#{node['moombot']['home']}/config.rb]", :immediately
  end

  begin
    include_recipe(
      "#{new_resource.cookbook}::plugin_delete_#{new_resource.name}")
  rescue Chef::Exceptions::RecipeNotFound
    Chef::Log.info("No recipe for `#{new_resource.name}` plugin action :delete")
  end
end
