#for dir in $(ls -l | awk '{print $9}' | cut -d '.' -f 1) ; do mkdir $dir;mv $dir.*.xz $dir;done
#for dir in $(ls -l | awk '{print $9}') ; do cd $dir ; tar xvf $dir*.tar*;cd .. ; done
ag -i err . > /tmp/err.txt
ag -i fatal . > /tmp/fatal.txt
ag -i exception . > /tmp/exception.txt
ag -i "FATAL -- : Error caught" . >> /tmp/fatal.txt
ag -i " Unable to perform refresh for the following targets:" . > /tmp/targetrefresh_err.txt
ag -i "Connection refused" . > /tmp/connection_err.txt
ag "requesting worker to exit" . |grep -v "uptime has reached" > /tmp/worker_exit.txt
ag NoMethodError . > /tmp/nomethod.txt
ag "rc=MIQ_STOP" . > /tmp/miq_stop.txt
ag "Server Role" . | grep -i last_startup.txt > /tmp/role.txt
ag "MemTotal:" . | grep -i last_startup.txt > /tmp/inventory.txt
ag   "MemAvailable:" . | grep -i last_startup.txt >> /tmp/inventory.txt
ag processor . | grep -v -i role |grep -v -i worker |grep -i last_startup.txt >> /tmp/inventory.txt
ag "cpu MHz" . | grep -i last_startup.txt >> /tmp/inventory.txt
ag "Segmentation fault" . > /tmp/seg_fault.txt

#https://bugzilla.redhat.com/show_bug.cgi?id=1435141
ag -i "pubsub_adapter" > /tmp/pubsub.txt

#https://bugzilla.redhat.com/show_bug.cgi?id=1354635
ag "Session object size of 1 MB exceeds" . > /tmp/1mb.txt

#db inconsistency
#select distinct resource_type from relationships ;
#>bads = Relationship.where(:resource_type=>'VmOrTemplate').select {|r| r.resource.nil?}
#>bads.each {|b| b.destroy}
ag "ActiveRecord::RecordNotFound" . > /tmp/activeerr.txt
#https://gss--c.na7.visual.force.com/apex/Case_View?id=500A000000XOkqt&sfdc.override=1
ag "InvalidRequest: Request missing value for required parameter" . > /tmp/missing_value.txt
