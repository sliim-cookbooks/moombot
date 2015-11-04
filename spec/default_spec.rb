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

  it 'creates cookbook_file[/opt/moombot/daemon]' do
    expect(subject).to create_cookbook_file('/opt/moombot/daemon')
      .with(source: 'daemon.rb',
            owner: 'moombot',
            group: 'moombot',
            mode: '0750')
  end

  it 'enables service[moombot]' do
    expect(subject).to enable_service('moombot')
  end

  it 'starts service[moombot]' do
    expect(subject).to start_service('moombot')
  end

  context 'with systemd' do
    let(:subject) do
      ChefSpec::SoloRunner.new do |node|
        node.set['init_package'] = 'systemd'
      end.converge(described_recipe)
    end

    it 'creates cookbook_file[/etc/systemd/system/moombot.service]' do
      service_file = '/etc/systemd/system/moombot.service'
      expect(subject).to create_cookbook_file(service_file)
        .with(source: 'service-systemd',
              owner: 'moombot',
              group: 'moombot',
              mode: '0644')
    end
  end

  context 'without systemd' do
    let(:subject) do
      ChefSpec::SoloRunner.new do |node|
        node.set['init_package'] = 'null'
      end.converge(described_recipe)
    end

    it 'creates cookbook_file[/etc/init.d/moombot]' do
      expect(subject).to create_cookbook_file('/etc/init.d/moombot')
        .with(source: 'service-init',
              owner: 'moombot',
              group: 'moombot',
              mode: '0755')
    end
  end
end
