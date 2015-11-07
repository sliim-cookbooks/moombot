# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe 'moombot' do
  subject { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'creates directory[/opt/moombot/plugins]' do
    expect(subject).to create_directory('/opt/moombot/plugins')
      .with(owner: 'moombot',
            group: 'moombot',
            mode: '0750')
  end

  it 'creates cookbook_file[/opt/moombot/plugins/ping.rb]' do
    expect(subject).to create_cookbook_file('/opt/moombot/plugins/ping.rb')
      .with(source: 'plugins/ping.rb',
            owner: 'moombot',
            group: 'moombot',
            mode: '0640')
  end

  it 'creates cookbook_file[/opt/moombot/plugins/server.rb]' do
    expect(subject).to create_cookbook_file('/opt/moombot/plugins/server.rb')
      .with(source: 'plugins/server.rb',
            owner: 'moombot',
            group: 'moombot',
            mode: '0640')
  end
end
