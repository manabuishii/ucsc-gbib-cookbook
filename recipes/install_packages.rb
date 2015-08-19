#
%w{
localepurge
zerofree
alpine
gpm
libgomp1
apache2
python-mysqldb
}.each do |p|
    package p do
    action :install
  end
end
