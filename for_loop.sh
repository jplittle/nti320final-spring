#!/bin/bash
for servername in $( gcloud compute instances list | awk '{print $1}' | sed "1 d" | grep -v nagios-server-final );  do 
    echo $servername;
    serverip=$( gcloud compute instances list | grep $servername | awk '{print $4}');
    echo $serverip ;
    bash /home/mnicho18/nti320final-spring/scp_to_nagios.sh $servername $serverip
done
gcloud compute ssh --zone us-west1-b mnicho18@nagios-server-final --command='sudo systemctl restart nagios'
