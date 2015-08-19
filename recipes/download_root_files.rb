# download /root/ files
%w{
updateBrowser.sh
addTools
changes.txt
cleanVm.sh
cronCleanTmp.sh
cronUpdate.sh
hg.conf.offline
lastUpdateTime.flag
mirrorTrack
testCleaner.sh
updateBrowser
urlIsNotNewerThanFile
zeroVm
}.each do |filename|
  remote_file "/root/#{filename}" do
    #action :nothing
    source "https://raw.githubusercontent.com/ucscGenomeBrowser/kent/master/src/browserbox/root/#{filename}"
    mode   0755
    retries 3
    not_if "test -f /root/#{filename}"
  end
end

# download /root/browserLogs/scripts
directory "/root/browserLogs/scripts" do
  recursive true
  mode 0755
  not_if "test -f /root/browserLogs/scripts"
end

#
# download /root/ files
%w{
dirStatsFromFind.pl
fileStatsFromFind.pl
measureTrash.sh
trashCleanMonitor.sh
trashCleaner.bash
trashSizeMonitor.sh
virtualBox.txt
}.each do |filename|
  remote_file "/root/browserLogs/scripts/#{filename}" do
    #action :nothing
    source "https://raw.githubusercontent.com/ucscGenomeBrowser/kent/master/src/browserbox/root/browserLogs/scripts/#{filename}"
    mode   0755
    retries 3
    not_if "test -f /root/browserLogs/scripts/#{filename}"
  end
end

# updateBrowser.sh needs /root/tableListAdd.hg19.tab
remote_file "/root/tableListAdd.hg19.tab" do
  source "http://hgdownload.cse.ucsc.edu/gbib/push/root/tableListAdd.hg19.tab"
  mode   0644
  retries 3
  not_if "test -f /root/tableListAdd.hg19.tab"
end

# install browser
bash 'for tableListAdd.hg19.tab' do
  code <<-EOH
  chmod 755 /root
  EOH
end

# setup updateBrowser and mysql
mysqluserandpassword="-uroot -pbrowser"
ruby_block "rewrite mysql user and password" do
  block do
    rc = Chef::Util::FileEdit.new("/root/updateBrowser.sh")
    #
    rc.search_file_replace(/mysql$/, "mysql #{mysqluserandpassword}")
    rc.search_file_replace(/^\s*mysql hg/, "mysql #{mysqluserandpassword} hg")
    rc.search_file_replace(/^\s*mysqlcheck \-\-all/, "mysqlcheck #{mysqluserandpassword} \-\-all")
    rc.search_file_replace(/mysql eboVir3/, "mysql #{mysqluserandpassword} eboVir3")
    rc.write_file
  end
  action :run
end
