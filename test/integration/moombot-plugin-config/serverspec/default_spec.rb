# -*- coding: utf-8 -*-

require 'spec_helper'

# TODO: Test bot message on channel

describe file '/opt/moombot-dev/plugins/say.rb' do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'moombot-dev' }
  it { should be_grouped_into 'moombot-dev' }
end
