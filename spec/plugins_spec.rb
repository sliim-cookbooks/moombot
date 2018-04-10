# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe 'moombot::plugins' do
  subject { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'creates directory[/opt/moombot/plugins]' do
    expect(subject).to create_directory('/opt/moombot/plugins')
      .with(owner: 'moombot',
            group: 'moombot',
            mode: '0750')
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
end
