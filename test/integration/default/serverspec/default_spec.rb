# -*- coding: utf-8 -*-

require 'spec_helper'

describe user 'moombot' do
  it { should exist }
  it { should belong_to_group 'moombot' }
  it { should have_login_shell '/bin/sh' }
end

describe group 'moombot' do
  it { should exist }
end

describe file '/opt/moombot/daemon' do
  it { should be_file }
  it { should be_executable }
  it { should be_owned_by 'moombot' }
  it { should be_grouped_into 'moombot' }
end

describe service 'moombot' do
  it { should be_running }
end
