# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe 'moombot::install' do
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

  it 'creates cookbook_file[/opt/moombot/daemon]' do
    expect(subject).to create_cookbook_file('/opt/moombot/daemon')
      .with(source: 'daemon.rb',
            owner: 'moombot',
            group: 'moombot',
            mode: '0750')
  end
end
