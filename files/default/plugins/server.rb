# -*- coding: utf-8 -*-

class ServerPlugin
  include Cinch::Plugin
  timer 60
  def timer
    IO.popen("echo get | nc localhost #{moombot[:server][:port]}") do |msgs|
      msgs.each_line do |msg|
        Channel(moombot[:cinch][:primary_channel]).send msg
      end
    end
  end
end

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
