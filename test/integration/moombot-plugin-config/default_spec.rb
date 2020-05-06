# TODO: Test bot message on channel

describe file '/opt/moombot-dev/plugins/say.rb' do
  it { should be_file }
  it { should be_mode 0640 }
  its(:owner) { should eq 'moombot-dev' }
  its(:group) { should eq 'moombot-dev' }
end
