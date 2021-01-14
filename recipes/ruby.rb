# Cookbook:: moombot
# Recipe:: ruby
# Copyright:: 2015-2021 Sliim

ohai 'reload-ruby-lang' do
  action :nothing
  plugin 'languages/ruby'
end

package 'ruby' do
  only_if { node['languages']['ruby'].empty? }
  notifies :reload, 'ohai[reload-ruby-lang]', :immediately
end
