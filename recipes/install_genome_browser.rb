# install genome browser
# get remote file
filename="installBrowser.sh"
fileurl="http://hgwdev.soe.ucsc.edu/~max/gbInstall/#{filename}"
filepath="#{Chef::Config['file_cache_path']}/#{filename}"
remote_file "#{filepath}" do
  #action :nothing
  source "#{fileurl}"
  mode   0755
  retries 3
  not_if "test -f #{filepath}"
  notifies :run, "ruby_block[comment out read]", :immediately
end
# comment out read -n 1 -s
ruby_block "comment out read" do
  block do
    rc = Chef::Util::FileEdit.new("#{filepath}")
    rc.search_file_replace(/^read/, "#read")
    rc.write_file
  end
  action :run
  notifies :run, "bash[install browser]", :immediately
end

# install browser
bash 'install browser' do
  cwd Chef::Config['file_cache_path']
  code <<-EOH
  ./#{filename}
  rm -rf /usr/local/apache/trash
  mkdir -p /data/trash/customTrash
  mkdir -p /data/gbdb
  chown -R www-data.www-data /data
  ln -s /data/trash /usr/local/apache/trash
  ln -s /var/lib/mysql /data/mysql
  chown -R mysql.mysql /var/lib/mysql
  touch "#{Chef::Config['file_cache_path']}/scriptrunning.txt"
  EOH
  action :nothing
  not_if "test -f #{Chef::Config['file_cache_path']}/scriptrunning.txt"
end
