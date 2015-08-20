require 'spec_helper'

describe "UCSC Genome Browser web" do
  getcommand = "curl http://localhost/"
  if ['debian', 'ubuntu'].include?(os[:family])
    getcommand = "wget http://localhost/ -O -"
  end
  describe command(getcommand) do
    its(:stdout) { should match /UCSC Genome Browser Home/ }
    its(:exit_status) { should eq 0 }
  end
end
