require 'spec_helper'


describe "mysql Daemon" do

  it "is listening on port 3306" do
    expect(port(3306)).to be_listening
  end

end
#
servicename="mysql"

if os[:family] == 'redhat'
  servicename="mysqld"
end

describe 'mysqld Daemon' do
  describe service(servicename) do
     it { should be_enabled }
     it { should be_running }
  end
end

# mysql command check
describe command('which mysql') do
  its(:exit_status) { should eq 0 }
end

describe 'MySQL config parameters' do
  context mysql_config('local-infile') do
    its(:value) { should eq "TRUE" }
  end

  #context mysql_config('default-storage-engine') do
  #  its(:value) { should eq 'MYISAM' }
  #end
end
