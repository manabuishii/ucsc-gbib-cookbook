# stop mysql at sysv-rc-conf
bash 'stop mysql at sysv-rc-conf' do
  cwd Chef::Config['file_cache_path']
  code <<-EOH
  sysv-rc-conf mysql off
  EOH
  action :run
  only_if { node[:ucscgbib][:removefromsysv] &&  File.exists?("/usr/sbin/sysv-rc-conf") }
end
