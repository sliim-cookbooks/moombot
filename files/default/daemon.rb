#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'cinch'
require 'daemons'

class MoomBotMsgPlugin
  include Cinch::Plugin
  timer 60, method: :get_messages
  def get_messages
    IO.popen("echo get | nc localhost #{moombot[:server][:port]}") do |msgs|
      msgs.each_line do |msg|
        Channel(moombot[:cinch][:channels][0].split(' ')[0]).send msg
      end
    end
  end
end

load File.expand_path('config.rb', File.dirname(__FILE__))

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

daemon_opts = { dir: moombot[:home] }

Daemons.run_proc(moombot[:name], daemon_opts) do
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

    on :message, 'ping' do |m|
      m.reply "#{m.user.nick}: pong"
    end
  end

  bot.loggers << Cinch::Logger::FormattedLogger.new(
    File.open("#{moombot[:home]}/#{moombot[:name]}.log", 'a+'))
  bot.loggers.level = :debug
  bot.loggers.first.level  = :info

  bot.start
end

Daemons.run_proc("#{moombot[:name]}-server") do
  server = TCPServer.new moombot[:server][:bind_address], moombot[:server][:port]
  M = Messages.new
  loop do
    Thread.start(server.accept) do |client|
      M.client = client
      M.query client.gets.strip
      client.close
    end
  end
end
