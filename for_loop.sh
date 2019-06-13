#!/bin/bash
for servername in $( gcloud compute instances list | awk '{print $1}' | sed "1 d" | grep -v nti320-final-nagios-server );  do 
    echo $servername;
    serverip=$( gcloud compute instances list | grep $servername | awk '{print $4}');
    echo $serverip ;
    bash /home/g42dfyt/Linux-Automation-3/scp_to_nagios.sh $servername $serverip
done
gcloud compute ssh --zone us-west1-b g42dfyt@nti320-final-nagios-server --command='sudo systemctl restart nagios'
