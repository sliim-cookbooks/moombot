# -*- coding: utf-8 -*-

class Plugin1Plugin
  include Cinch::Plugin
  match 'hello', use_prefix: false, use_suffix: false
  def execute(m)
    m.reply "Hello #{m.user.nick}"
  end
end
