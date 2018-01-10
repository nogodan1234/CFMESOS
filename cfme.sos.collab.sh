#for dir in $(ls -l | awk '{print $9}' | cut -d '.' -f 1) ; do mkdir $dir;mv $dir.*.xz $dir;done
#for dir in $(ls -l | awk '{print $9}') ; do cd $dir ; tar xvf $dir*.tar*;cd .. ; done
rm -rf /tmp/tachoi
mkdir /tmp/tachoi
fgrep -r -i err . > /tmp/tachoi/err.txt
fgrep -r -i fatal . > /tmp/tachoi/fatal.txt
fgrep -r -i exception . > /tmp/tachoi/exception.txt
fgrep -r -i "FATAL -- : Error caught" . >> /tmp/tachoi/fatal.txt
fgrep -r -i " Unable to perform refresh for the following targets:" . > /tmp/tachoi/targetrefresh_err.txt
fgrep -r -i "Connection refused" . > /tmp/tachoi/connection_err.txt

fgrep -r NoMethodError . > /tmp/tachoi/nomethod.txt
fgrep -r "rc=MIQ_STOP" . > /tmp/tachoi/miq_stop.txt
fgrep -r "Server Role" . | grep -i last_startup.txt > /tmp/tachoi/role.txt
fgrep -r "MemTotal:" . | grep -i last_startup.txt > /tmp/tachoi/inventory.txt
fgrep -r   "MemAvailable:" . | grep -i last_startup.txt >> /tmp/tachoi/inventory.txt
fgrep -r processor . | grep -v -i role |grep -v -i worker |grep -i last_startup.txt >> /tmp/tachoi/inventory.txt
fgrep -r "cpu MHz" . | grep -i last_startup.txt >> /tmp/tachoi/inventory.txt
fgrep -r "Segmentation fault" . > /tmp/tachoi/seg_fault.txt
fgrep -r "CloudManager::Vm#perform_metadata_scan\|CloudManager::Vm#scan_via_miq_vm) Completed:" . > /tmp/tachoi/SSA_time.txt

#https://bugzilla.redhat.com/show_bug.cgi?id=1435141
fgrep -r -i "pubsub_adapter" > /tmp/tachoi/pubsub.txt

#https://bugzilla.redhat.com/show_bug.cgi?id=1354635
fgrep -r "Session object size of 1 MB exceeds" . > /tmp/tachoi/1mb.txt

#db inconsistency
#select distinct resource_type from relationships ;
#>bads = Relationship.where(:resource_type=>'VmOrTemplate').select {|r| r.resource.nil?}
#>bads.each {|b| b.destroy}
fgrep -r "ActiveRecord::RecordNotFound" . > /tmp/tachoi/activeerr.txt
#https://gss--c.na7.visual.force.com/apex/Case_View?id=500A000000XOkqt&sfdc.override=1
fgrep -r "InvalidRequest: Request missing value for required parameter" . > /tmp/tachoi/missing_value.txt


#worker restart issue
fgrep -r "MiqServer#validate_worker" . |grep -v "uptime has reached" | grep "requesting worker to exit" > /tmp/tachoi/worker_exit.txt
echo "#### Worker needs increase memory ###" >> /tmp/tachoi/worker_exit.txt
fgrep -r "MiqServer#validate_worker" . |grep -v "uptime has reached" | grep "requesting worker to exit" | awk '{print $10}' | sort -u >> /tmp/tachoi/worker_exit.txt
fgrep -r "MiqServer#validate_worker" . |grep -v "uptime has reached" | grep "restarting worker" | grep "has not responded" > /tmp/tachoi/worker_noresponse.txt
echo "#### Worker that hasn't been responded in time ####" >> /tmp/tachoi/worker_noresponse.txt
fgrep -r "MiqServer#validate_worker" . |grep -v "uptime has reached" | grep "restarting worker" | grep "has not responded"| awk '{print $10}' | sort -u >> /tmp/tachoi/worker_noresponse.txt
fgrep -r "MIQ(MiqServer#start_algorithm_used_swap_percent_lt_value)" . | grep "Not allowing worker" > /tmp/tachoi/worker_swap.txt

#Performance check
#grep 'count for state=\["dequeue"\]' evm.log
#"Dequeued in" value
#"Delivered in" value 

#Any lines matched by this search can be traced back using the PID field in the log line to determine
#the operation that was in process when the message timeout occurred.
fgrep -r "Message id: \[\d+\], timed out after" . > /tmp/tachoi/msg_timeout.txt


#Check full refresh time info for each step
fgrep -r "Refreshing targets for EMS...Complete" . > /tmp/tachoi/full_refresh.txt

#https://bugzilla.redhat.com/show_bug.cgi?id=1341867
fgrep -r "Unable to mount filesystem.  Reason" . > /tmp/tachoi/SSA_mount.txt

#seeding issue 
fgrep -r "You cannot call create unless the parent is saved" . > /tmp/tachoi/Seeding.txt
#https://gss--c.na7.visual.force.com/apex/Case_View?srPos=0&srKp=500&id=500A000000Yfsu2&sfdc.override=1#comment_a0aA000000KundiIAB

#Azure string err - https://bugzilla.redhat.com/show_bug.cgi?id=1504314
fgrep -r "can't convert String into time interval" . > /tmp/tachoi/azure_string.txt

#OSP excon timeout reached bz: 1522842
fgrep -r "[ERROR -- : excon.error     #<Excon::Error::Timeout: read timeout reached>" . > /tmp/tachoi/excon_timeout.txt

#Event Storm from provider
echo "#### Event Storm Check ####" > /tmp/tachoi/event_strom.txt
fgrep -r "Processing EMS event" . | grep Complete | awk '{print $12}' | wc -l >> /tmp/tachoi/event_strom.txt
echo "#### Event name ####" >> /tmp/tachoi/event_strom.txt
find . -name evm.log -exec grep "Processing EMS event" {} \; | grep Complete | awk '{print $12}' | sort -u >> /tmp/tachoi/event.txt
sed -i -e 's/\[//g' /tmp/tachoi/event.txt
sed -i -e 's/\]//g' /tmp/tachoi/event.txt
#for id in $(cat /tmp/tachoi/event.txt); do grep $id evm.log |grep Complete |wc -l ;done >> /tmp/tachoi/event.txt

#Postgres Connection Error
find . -name evm.log -exec grep "PG::ConnectionBad" {} \; |grep ERROR > /tmp/tachoi/pgcon_err.txt




