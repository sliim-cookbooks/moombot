# -*- coding: utf-8 -*-

class ServerPlugin
  include Cinch::Plugin
  timer 30
  def timer
    client = Client.new
    client.get.each do |msg|
      Channel(moombot[:cinch][:primary_channel]).send msg
    end
    client.close
  end

  class Client
    def initialize()
      @client = TCPSocket.new '127.0.0.1', moombot[:server][:port]
    end

    def add(message)
      @client.puts "add:#{message}"
    end

    def get
      @client.puts 'get'
      result = []
      while line = @client.gets
        result << line
      end
      return result
    end

    def close
      @client.close
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
