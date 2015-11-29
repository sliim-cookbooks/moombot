# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe 'moombot::configure' do
  subject { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'creates template[/opt/moombot/config.rb]' do
    expect(subject).to create_template('/opt/moombot/config.rb')
      .with(source: 'config.rb.erb',
            owner: 'moombot',
            group: 'moombot',
            mode: '0640')
  end
end
