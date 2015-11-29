#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'cinch'
require 'daemons'

load File.expand_path('config.rb', File.dirname(__FILE__))

Daemons.run_proc(moombot[:name], dir: moombot[:home]) do
  bot = Cinch::Bot.new do
    configure do |c|
      c.server = moombot[:cinch][:server]
      c.port = moombot[:cinch][:port,]
      c.nick = moombot[:cinch][:nick]
      c.realname = moombot[:cinch][:nick].capitalize
      c.user = moombot[:cinch][:nick]
      c.channels = moombot[:cinch][:channels]

      c.ssl = moombot[:cinch][:ssl]
      c.plugins.plugins = moombot[:cinch][:plugins]
    end
  end

  bot.loggers << Cinch::Logger::FormattedLogger.new(
    File.open("#{moombot[:home]}/#{moombot[:name]}.log", 'a+'))
  bot.loggers.level = :debug
  bot.loggers.first.level = :info

  bot.start
end
