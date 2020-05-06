require_relative 'spec_helper'

describe 'moombot' do
  subject { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'installs package[ruby]' do
    expect(subject).to install_package('ruby')
  end

  %w(cinch daemons).each do |pkg|
    it "installs gem_package[#{pkg}]" do
      expect(subject).to install_gem_package(pkg)
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

  it 'creates directory[/opt/moombot/plugins]' do
    expect(subject).to create_directory('/opt/moombot/plugins')
      .with(owner: 'moombot',
            group: 'moombot',
            mode: '0750')
  end

  context 'plugin lwrp with default attributes' do
    let(:subject) do
      ChefSpec::SoloRunner.new(
        step_into: ['moombot_plugin']).converge described_recipe
    end

    %w(ping server).each do |plugin|
      it "creates moombot_plugin[#{plugin}]" do
        expect(subject).to create_moombot_plugin(plugin)
      end
    end

    it 'creates cookbook_file[/opt/moombot/plugins/ping.rb]' do
      expect(subject).to create_cookbook_file('/opt/moombot/plugins/ping.rb')
        .with(source: 'plugins/ping.rb',
              cookbook: 'moombot',
              owner: 'moombot',
              group: 'moombot',
              mode: '0640')
    end

    it 'creates cookbook_file[/opt/moombot/plugins/server.rb]' do
      expect(subject).to create_cookbook_file('/opt/moombot/plugins/server.rb')
        .with(source: 'plugins/server.rb',
              cookbook: 'moombot',
              owner: 'moombot',
              group: 'moombot',
              mode: '0640')
    end
  end

  context 'plugins attribute is kind of Array' do
    let(:subject) do
      ChefSpec::SoloRunner.new do |node|
        node.override['moombot']['plugins'] = %w(plugin1 plugin2)
      end.converge described_recipe
    end

    [1, 2].each do |i|
      it "creates moombot_plugin[plugin#{i}]" do
        expect(subject).to create_moombot_plugin("plugin#{i}")
      end
    end
  end

  context 'plugins attribute is kind of Hash' do
    let(:subject) do
      ChefSpec::SoloRunner.new do |node|
        node.override['moombot']['plugins'] = { moombot: %w(plugin1 plugin2),
                                                devbot: %w(plugin3 plugin4) }
      end.converge described_recipe
    end

    [1, 2].each do |i|
      it "creates moombot_plugin[plugin#{i}]" do
        expect(subject).to create_moombot_plugin("plugin#{i}")
          .with(cookbook: 'moombot')
      end
    end

    [3, 4].each do |i|
      it "creates moombot_plugin[plugin#{i}]" do
        expect(subject).to create_moombot_plugin("plugin#{i}")
          .with(cookbook: 'devbot')
      end
    end
  end

  it 'creates template[/opt/moombot/config.rb]' do
    expect(subject).to create_template('/opt/moombot/config.rb')
      .with(source: 'config.rb.erb',
            owner: 'moombot',
            group: 'moombot',
            mode: '0640')
  end

  it 'enables service[moombot]' do
    expect(subject).to enable_service('moombot')
  end

  context 'with systemd' do
    let(:subject) do
      ChefSpec::SoloRunner.new do |node|
        node.automatic['init_package'] = 'systemd'
      end.converge(described_recipe)
    end

    it 'creates template[/etc/systemd/system/moombot.service]' do
      service_file = '/etc/systemd/system/moombot.service'
      expect(subject).to create_template(service_file)
        .with(source: 'service-systemd.erb',
              owner: 'moombot',
              group: 'moombot',
              mode: '0644')
    end
  end

  context 'without systemd' do
    let(:subject) do
      ChefSpec::SoloRunner.new do |node|
        node.automatic['init_package'] = 'init'
      end.converge(described_recipe)
    end

    it 'creates template[/etc/init.d/moombot]' do
      expect(subject).to create_template('/etc/init.d/moombot')
        .with(source: 'service-init.erb',
              owner: 'moombot',
              group: 'moombot',
              mode: '0755')
    end
  end
end
