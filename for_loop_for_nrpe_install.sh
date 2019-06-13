for servername in $( gcloud compute instances list | awk '{print $1}' | sed "1 d" | grep -v nti320-final-nagios-server );  do 
    gcloud compute ssh --zone us-west1-b g42dfyt@$servername --command='sudo yum -y install wget && sudo wget https://raw.githubusercontent.com/DFYT42/Linux-Automation-3/master/nagios-client-configuration.sh && sudo bash nagios-client-configuration.sh'
done