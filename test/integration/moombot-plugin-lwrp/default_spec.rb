describe file '/opt/moombot-dev/plugins/ping.rb' do
  it { should be_file }
  it { should be_mode 0640 }
  its(:owner) { should eq 'moombot-dev' }
  its(:group) { should eq 'moombot-dev' }
end

describe file '/opt/moombot-dev/plugins/plugin1.rb' do
  it { should be_file }
  it { should be_mode 0640 }
  its(:owner) { should eq 'moombot-dev' }
  its(:group) { should eq 'moombot-dev' }
end

describe file '/opt/moombot-dev/plugins/server.rb' do
  it { should_not be_file }
end

describe file '/opt/moombot-dev/plugins/plugin2.rb' do
  it { should_not be_file }
end

['/tmp/plugin1_created',
 '/tmp/plugin2_created',
 '/tmp/plugin2_deleted'].each do |f|
  describe file f do
    it { should be_file }
  end
end
