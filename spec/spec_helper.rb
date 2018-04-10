# -*- coding: utf-8 -*-
require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.platform = 'debian'
  config.version = '9.4'
end

ChefSpec::Coverage.start! { add_filter 'moombot' }

require 'chef/application'
