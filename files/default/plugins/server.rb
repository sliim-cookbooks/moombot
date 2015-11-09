# -*- coding: utf-8 -*-

class ServerPlugin
  include Cinch::Plugin
  timer 30
  def timer
    client = Client.new
    client.get.each do |msg|
      Channel(moombot[:cinch][:primary_channel]).send msg
    end
  end

  class Client
    def add(message)
      c = client
      c.puts "add:#{message}"
      c.close
    end

    def get
      c = client
      c.puts 'get'
      result = []
      while line = c.gets
        result << line
      end
      c.close
      return result
    end

    private
    def client
      TCPSocket.new '127.0.0.1', moombot[:server][:port]
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
end

Daemons.run_proc("#{moombot[:name]}-server", { dir: moombot[:home] }) do
  server = TCPServer.new moombot[:server][:bind_address], moombot[:server][:port]
  M = ServerPlugin::Messages.new
  loop do
    Thread.start(server.accept) do |client|
      M.client = client
      M.query client.gets.strip
      client.close
    end
  end
end
