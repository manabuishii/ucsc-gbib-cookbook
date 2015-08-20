require 'spec_helper'

describe "UCSC Genome Browser hgGateway" do
  getcommand = "curl http://localhost/cgi-bin/hgGateway"
  if ['debian', 'ubuntu'].include?(os[:family])
    getcommand = "wget http://localhost/cgi-bin/hgGateway -O -"
  end
  describe command(getcommand) do
    its(:stdout) { should match /Genome Browser Gateway/ }
    its(:exit_status) { should eq 0 }
  end
end

describe "UCSC Genome Browser hgTracks" do
  getcommand = "curl http://localhost/cgi-bin/hgTracks"
  if ['debian', 'ubuntu'].include?(os[:family])
    getcommand = "wget http://localhost/cgi-bin/hgTracks -O -"
  end
  describe command(getcommand) do
    its(:stdout) { should match /UCSC Genome Browser/ }
    its(:exit_status) { should eq 0 }
  end
end
