describe user 'moombot-dev' do
  it { should exist }
  its(:group) { should eq 'moombot-dev' }
  its(:shell) { should eq '/bin/sh' }
end

describe group 'moombot-dev' do
  it { should exist }
end

describe file '/opt/moombot-dev/config.rb' do
  it { should be_file }
  it { should be_mode 0640 }
  its(:owner) { should eq 'moombot-dev' }
  its(:group) { should eq 'moombot-dev' }
end

describe file '/opt/moombot-dev/daemon' do
  it { should be_file }
  it { should be_executable }
  its(:owner) { should eq 'moombot-dev' }
  its(:group) { should eq 'moombot-dev' }
end

describe file '/opt/moombot-dev/plugins/ping.rb' do
  it { should be_file }
  it { should be_mode 0640 }
  its(:owner) { should eq 'moombot-dev' }
  its(:group) { should eq 'moombot-dev' }
end

describe file '/opt/moombot-dev/plugins/server.rb' do
  it { should be_file }
  it { should be_mode 0640 }
  its(:owner) { should eq 'moombot-dev' }
  its(:group) { should eq 'moombot-dev' }
end

['moombot-dev.pid',
 'moombot-dev-server.pid',
 'moombot-dev.log'].each do |f|
  describe file "/opt/moombot-dev/#{f}" do
    it { should be_file }
  end
end
