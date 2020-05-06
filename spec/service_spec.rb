require_relative 'spec_helper'

describe 'moombot::service' do
  subject { ChefSpec::SoloRunner.new.converge(described_recipe) }

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
