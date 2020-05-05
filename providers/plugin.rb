# Cookbook:: moombot
# Provider:: plugin
# Copyright:: 2015-2020 Sliim

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
    notifies :restart, "service[#{node['moombot']['name']}]", :delayed
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
  end

  begin
    include_recipe(
      "#{new_resource.cookbook}::plugin_delete_#{new_resource.name}")
  rescue Chef::Exceptions::RecipeNotFound
    Chef::Log.info("No recipe for `#{new_resource.name}` plugin action :delete")
  end
end
