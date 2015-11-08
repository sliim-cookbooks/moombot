# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe 'moombot' do
  subject { ChefSpec::SoloRunner.new.converge(described_recipe) }

  %w(cinch daemons).each do |pkg|
    it "installs package[#{pkg}]" do
      expect(subject).to install_gem_package(pkg)
        .with(gem_binary: '/opt/chef/embedded/bin/gem')
    end
  end

  it 'creates group[moombot]' do
    expect(subject).to create_group('moombot')
  end

  it 'creates user[moombot]' do
    expect(subject).to create_user('moombot')
      .with(system: true,
            group: 'moombot',
            shell: '/bin/sh',
            home: '/opt/moombot')
  end

  it 'creates directory[/opt/moombot]' do
    expect(subject).to create_directory('/opt/moombot')
      .with(owner: 'moombot',
            group: 'moombot',
            mode: '0750',
            recursive: true)
  end

  it 'includes recipe[moombot::service]' do
    expect(subject).to include_recipe('moombot::service')
  end

  it 'includes recipe[moombot::plugins]' do
    expect(subject).to include_recipe('moombot::plugins')
  end

  it 'creates template[/opt/moombot/config.rb]' do
    expect(subject).to create_template('/opt/moombot/config.rb')
      .with(source: 'config.rb.erb',
            owner: 'moombot',
            group: 'moombot',
            mode: '0640')
  end

  it 'creates cookbook_file[/opt/moombot/daemon]' do
    expect(subject).to create_cookbook_file('/opt/moombot/daemon')
      .with(source: 'daemon.rb',
            owner: 'moombot',
            group: 'moombot',
            mode: '0750')
  end
end
