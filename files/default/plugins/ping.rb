# Cookbook:: moombot
# File:: plugins/ping.rb
# Copyright:: 2015-2020 Sliim

# PingPlugin
class PingPlugin
  include Cinch::Plugin
  match 'ping', use_prefix: false, use_suffix: false
  def execute(m)
    m.reply "#{m.user.nick}: pong"
  end
end
