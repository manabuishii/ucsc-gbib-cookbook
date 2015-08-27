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
removefromsysv=""
if node[:ucscgbib][:removefromsysv]
  removefromsysv="sysv-rc-conf mysql off"
end
bash 'install browser' do
  cwd Chef::Config['file_cache_path']
  code <<-EOH
  #{removefromsysv}
  service mysql restart
  ./#{filename}
  rm -rf /usr/local/apache/trash
  mkdir -p /data/trash/customTrash
  mkdir -p /data/trash/ct
  mkdir -p /data/gbdb
  chown -R www-data.www-data /data
  mkdir /usr/local/apache/userdata
  chown -R www-data.www-data /usr/local/apache/userdata
  ln -s /data/trash /usr/local/apache/trash
  ln -s /var/lib/mysql /data/mysql
  chown -R mysql.mysql /var/lib/mysql
  cp /usr/local/apache/cgi-bin/hg.conf.local /root/hg.conf.local
  chmod 600 /root/hg.conf.local
  echo "include /usr/local/apache/cgi-bin/hg.conf" > /root/browserLogs/scripts/.hg.${HOSTNAME}.conf
  chmod 600 /root/browserLogs/scripts/.hg.${HOSTNAME}.conf
  wget https://raw.githubusercontent.com/ucscGenomeBrowser/kent/ae4aa88945e566f60c950226ab06cbd2ee749789/src/hg/lib/metaInfo.sql -O /root/metaInfo.sql
  mysql -uroot -pbrowser customTrash < /root/metaInfo.sql
  touch "#{Chef::Config['file_cache_path']}/scriptrunning.txt"
  EOH
  action :nothing
  not_if "test -f #{Chef::Config['file_cache_path']}/scriptrunning.txt"
end
