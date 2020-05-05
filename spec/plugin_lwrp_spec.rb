require 'chefspec'
require 'chefspec/berkshelf'

describe 'plugin lwrp with default attributes' do
  let(:subject) do
    ChefSpec::SoloRunner.new(
      step_into: ['moombot_plugin']).converge 'moombot::plugins'
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
