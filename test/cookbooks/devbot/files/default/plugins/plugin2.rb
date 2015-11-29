# -*- coding: utf-8 -*-
class Plugin2Plugin
  include Cinch::Plugin
  match 'hi!', use_prefix: false, use_suffix: false
  def execute(m)
    m.reply "Hi #{m.user.nick}!"
  end
end
