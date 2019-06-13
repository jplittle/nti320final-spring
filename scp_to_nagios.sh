#!/bin/bash
bash /home/mnicho18/nti320final-spring/generate_config.sh $1 $2
gcloud compute scp --zone us-west1-b $1.cfg g42dfyt@nti320-final-nagios-server:/etc/nagios/servers
# Note: 
#Nagios server code near bottom: I had to add user nicolebade to group nagios on nagios server using usermod -a -G nagios mnicho18
# I also had to chmod 777 /etc/nagios/servers
gcloud compute ssh --zone us-west1-b mnicho18@nagios-server-final --command='sudo /usr/sbin/nagios -v /etc/nagios/nagios.cfg'