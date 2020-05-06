# Cookbook:: moombot
# Recipe:: default
# Copyright:: 2015-2020 Sliim

package 'ruby'

%w(cinch daemons).each do |pkg|
  gem_package pkg
end

group node['moombot']['name']

user node['moombot']['name'] do
  group node['moombot']['name']
  system true
  shell '/bin/sh'
  home node['moombot']['home']
end

directory node['moombot']['home'] do
  owner node['moombot']['name']
  group node['moombot']['name']
  mode '0750'
  recursive true
end

cookbook_file "#{node['moombot']['home']}/daemon" do
  source 'daemon.rb'
  owner node['moombot']['name']
  group node['moombot']['name']
  mode '0750'
end

directory "#{node['moombot']['home']}/plugins" do
  owner node['moombot']['name']
  group node['moombot']['name']
  mode '0750'
end

if node['moombot']['plugins'].is_a? ::Chef::Node::ImmutableArray
  node.override['moombot']['plugin_list'] = node['moombot']['plugins']
  node['moombot']['plugins'].each do |name|
    moombot_plugin name
  end
elsif node['moombot']['plugins'].is_a? ::Chef::Node::ImmutableMash
  node.override['moombot']['plugin_list'] =
    node['moombot']['plugins'].map { |_k, v| v }.flatten
  node['moombot']['plugins'].each do |cookbook_name, plugins|
    plugins.each do |name|
      moombot_plugin name do
        cookbook cookbook_name
      end
    end
  end
else
  Chef::Log.warn('Cannot determine plugins list, '\
                 'attribute must be an Array or a Hash')
end

template "#{node['moombot']['home']}/config.rb" do
  source 'config.rb.erb'
  owner node['moombot']['name']
  group node['moombot']['name']
  mode '0640'
  variables name: node['moombot']['name'],
            home: node['moombot']['home'],
            cinch: node['moombot']['cinch'],
            plugins: lazy { node['moombot']['plugin_list'] },
            loggers: node['moombot']['loggers']
  notifies :restart, "service[#{node['moombot']['name']}]", :delayed
end

if node['init_package'] == 'systemd'
  template "/etc/systemd/system/#{node['moombot']['name']}.service" do
    source 'service-systemd.erb'
    owner node['moombot']['name']
    group node['moombot']['name']
    mode '0644'
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
    notifies :restart, "service[#{node['moombot']['name']}]", :delayed
  end
else
  template "/etc/init.d/#{node['moombot']['name']}" do
    source 'service-init.erb'
    owner node['moombot']['name']
    group node['moombot']['name']
    mode '0755'
    notifies :restart, "service[#{node['moombot']['name']}]", :delayed
  end
end

service node['moombot']['name'] do
  action :enable
  supports status: true, start: true, stop: true, restart: true
  subscribes :restart,
             "cookbook_file[#{node['moombot']['home']}/daemon]", :delayed
  subscribes :restart,
             "template[#{node['moombot']['home']}/config.rb]", :delayed
end

execute 'systemctl-daemon-reload' do
  action :nothing
  command 'systemctl daemon-reload'
end
