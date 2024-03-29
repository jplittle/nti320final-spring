# Usage:
# check_ldap_sync
define command {
	command_name    check_ldap_sync
	command_line    /usr/lib/nagios/plugins/check_ldap_sync -H $HOSTADDRESS$ $ARG1$
}

define service {
	use                     generic-service
	name                    ldap_sync
	service_description     ldap_sync
	register                0

	normal_check_interval   30
	retry_check_interval    60

	notification_interval   15

	check_command           check_ldap_sync
}