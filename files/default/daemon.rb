#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'cinch'
require 'daemons'
# require 'socket'

class Messages
  attr_writer :client
  def initialize
    @messages = []
  end

  def query q
    case q[0..2].to_sym
    when :add
      add q[4..-1]
    when :get
      get
    end
  end

  def add(msg)
    @messages << msg
  end

  def get
    @messages.each { |msg| @client.puts msg }
    @messages = []
  end
end

class MoomBotMsgPlugin
  include Cinch::Plugin
  timer 60, method: :get_messages
  def get_messages
    IO.popen('echo get | nc localhost 840807') do |msgs|
      msgs.each_line do |msg|
        Channel("#badtoken").send msg
      end
    end
  end
end

# moombot_name = Socket.gethostname
moombot_name = 'moombot-dev'
moombot_home = '/opt/moombot'
daemon_opts = { dir: moombot_home }

Daemons.run_proc('moombot', daemon_opts) do
  bot = Cinch::Bot.new do
    configure do |c|
      c.server = 'irc.hackint.eu'
      c.port = 9999
      c.nick = moombot_name
      c.realname = moombot_name.capitalize
      c.user = moombot_name
      c.channels = ['#moombot-dev']

      c.ssl = Cinch::Configuration::SSL.new(use: true,
                                            verify: false)
      c.plugins.plugins = [MoomBotMsgPlugin]
    end

    on :message, 'ping' do |m|
      m.reply "#{m.user.nick}: pong"
    end
  end

  bot.loggers << Cinch::Logger::FormattedLogger.new(
    File.open("#{moombot_home}/moombot.log", 'a+'))
  bot.loggers.level = :debug
  bot.loggers.first.level  = :info

  bot.start
end

Daemons.run_proc('moombot-server') do
  server = TCPServer.new '127.0.0.1', 840807
  M = Messages.new
  loop do
    Thread.start(server.accept) do |client|
      M.client = client
      M.query client.gets.strip
      client.close
    end
  end
end
