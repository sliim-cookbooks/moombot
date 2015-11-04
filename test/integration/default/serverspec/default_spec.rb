# -*- coding: utf-8 -*-

require 'spec_helper'

describe user 'moombot-dev' do
  it { should exist }
  it { should belong_to_group 'moombot-dev' }
  it { should have_login_shell '/bin/sh' }
end

describe group 'moombot-dev' do
  it { should exist }
end

describe file '/opt/moombot-dev/config.rb' do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'moombot-dev' }
  it { should be_grouped_into 'moombot-dev' }
end

describe file '/opt/moombot-dev/daemon' do
  it { should be_file }
  it { should be_executable }
  it { should be_owned_by 'moombot-dev' }
  it { should be_grouped_into 'moombot-dev' }
end

describe service 'moombot-dev' do
  it { should be_running }
end

['moombot-dev.pid',
 'moombot-dev-server.pid',
 'moombot-dev.log'].each do |f|
  describe file "/opt/moombot-dev/#{f}" do
    it { should be_file }
  end
end
