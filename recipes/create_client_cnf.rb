mysqlservice="/etc/init.d/mysql"
case node[:platform]
when "ubuntu"
  mysqlservice="service mysql"
end

bash "restartmysql" do
  action :nothing
  code   <<-EOH
     #{mysqlservice} restart
  EOH
end

template "/etc/mysql/conf.d/client.cnf" do
  source 'client.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  #action :nothing
  notifies :run, "bash[restartmysql]", :immediately
end
