require 'serverspec'

set :backend, :exec
#set :backend, :ssh

RSpec.configure do |c|
  c.output_stream = File.open('/tmp/result/serverspec-result.xml', 'w')
  c.formatter = 'RspecJunitFormatter'
end
