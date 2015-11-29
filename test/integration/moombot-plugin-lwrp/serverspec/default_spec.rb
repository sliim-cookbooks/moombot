# -*- coding: utf-8 -*-

require 'spec_helper'

describe file '/opt/moombot-dev/plugins/ping.rb' do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'moombot-dev' }
  it { should be_grouped_into 'moombot-dev' }
end

describe file '/opt/moombot-dev/plugins/plugin1.rb' do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'moombot-dev' }
  it { should be_grouped_into 'moombot-dev' }
end

describe file '/opt/moombot-dev/plugins/server.rb' do
  it { should_not be_file }
end

describe file '/opt/moombot-dev/plugins/plugin2.rb' do
  it { should_not be_file }
end

['/tmp/plugin1_created',
 '/tmp/plugin2_created',
 '/tmp/plugin2_deleted'].each do |f|
  describe file f do
    it { should be_file }
  end
end
