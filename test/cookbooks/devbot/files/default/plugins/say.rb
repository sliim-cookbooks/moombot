class SayPlugin
  include Cinch::Plugin
  timer 2
  def timer
    Channel(moombot['cinch']['primary_channel']).send moombot_say['msg']
  end
end
