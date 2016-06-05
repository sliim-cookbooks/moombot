#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'cinch'
require 'daemons'
load File.expand_path('config.rb', File.dirname(__FILE__))

Daemons.run_proc(moombot['name'], dir: moombot['home']) do
  bot = Cinch::Bot.new do
    configure do |c|
      c.server = moombot['cinch']['server']
      c.port = moombot['cinch']['port']
      c.nick = moombot['cinch']['nick']
      c.realname = moombot['cinch']['nick'].capitalize
      c.user = moombot['cinch']['nick']
      c.channels = moombot['cinch']['channels']
      c.plugins.plugins = moombot['plugins'].map do |p|
        Object.const_get(p.capitalize << 'Plugin')
      end
      if moombot['cinch']['ssl']
        c.ssl = Cinch::Configuration::SSL.new(
          'use' => moombot['cinch']['ssl']['use'],
          'verify' => moombot['cinch']['ssl']['verify'])
      end
    end
  end

  bot.loggers << Cinch::Logger::FormattedLogger.new(
    File.open("#{moombot['home']}/#{moombot['name']}.log", 'a+'))
  bot.loggers.level = moombot['loggers']['level'].to_sym
  bot.loggers.first.level = moombot['loggers']['first_level'].to_sym
  bot.start
end
