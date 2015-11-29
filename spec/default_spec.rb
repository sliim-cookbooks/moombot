# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe 'moombot' do
  subject { ChefSpec::SoloRunner.new.converge(described_recipe) }

  %w(install service plugins configure).each do |recipe|
    it "includes recipe[moombot::#{recipe}]" do
      expect(subject).to include_recipe("moombot::#{recipe}")
    end
  end
end
