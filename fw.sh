#!/bin/bash - 
#===============================================================================
#
#          FILE: fw.sh
# 
#         USAGE: ./fw.sh 
# 
#   DESCRIPTION: Parameterisierte konfiguration von CF-Karten
# 
#       OPTIONS: a b d e f h v 
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Juri Grabowski, 
#  ORGANIZATION: LiHAS
#       CREATED: 11/06/12 00:36:18 CET
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
#!/bin/bash
# Skript: fw.sh
# Zweck: Parameterisierte konfiguration von CF-Karten

# Globale Variablen
SCRIPTNAME=$(basename $0 .sh)
	EXIT_SUCCESS=0
	EXIT_FAILURE=1
	EXIT_ERROR=2
	EXIT_BUG=10

#	SEARCH_HOSTNAME="gw1-bart"
#	SEARCH_OTHERSIDE_HOSTNAME="gw2-bart"
##	SEARCH_OTHERSIDE_IP="192.168.50.2"
##	SEARCH_INET_DEV="eth0"
##	SEARCH_HA_DEV="eth1"
##	SEARCH_INTERN_DEV="eth2"
##	SEARCH_INET_DEV_IP="192.168.7.2"
##	SEARCH_HA_DEV_IP="192.168.50.1"
#	SEARCH_INTERN_DEV_IP="10.10.0.252"
#	SEARCH_VIRT_INTERN_DEV_IP="10.10.0.254"
#	SEARCH_INTERN_DEV_BROADCAST="10.10.0.255"
#	SEARCH_OTHERSIDE_INTERN_DEV_IP="10.10.0.253"
##	SEARCH_INET_DEV_MASK="255.255.255.0"
##	SEARCH_HA_DEV_MASK="255.255.255.252"
##	SEARCH_INTERN_DEV_MASK="255.255.255.0"
	SEARCH_VLAN254_MAC="00:0d:b9:29:00:fe"
	SEARCH_VLAN253_MAC="00:0d:b9:29:00:fd"
	KUNDE="wilhelmshilfe"
	ROOT_DIR="/root/"


# Variablen fuer Optionsschalter hier mit Default-Werten vorbelegen
	VERBOSE=n
	OPTFILE=""
	FILE_HOSTS="/etc/hosts"
	FILE_INTERFACES="/etc/network/interfaces"
	FILE_HOSTNAME="/etc/hostname"
	FILE_FIREWALL="/etc/firewall.lihas.d/interface-eth2/network"
	FILE_HA_CF="/etc/ha.d/ha.cf"
	FILE_DNSMASQ_CFG="/etc/dnsmasq.more.conf"
	FILE_CIB="/var/lib/heartbeat/crm/cib.xml"
	FILE_SSH_CONFIG="/root/.ssh/config"
	HOSTNAME="gw#-Standort"
	OTHERSIDE_HOSTNAME="gw+-Standort"
	OTHERSIDE_IP="192.168.50.2"
	INET_DEV="eth0"
	HA_DEV="eth1"
	INTERN_DEV="eth2"
	INTERN_DEV_BROADCAST="10.83.87.255"
	INET_DEV_IP="192.168.7.2"
	HA_DEV_IP="192.168.50.1"
	INTERN_DEV_IP="10.83.87.252"
	VIRT_INTERN_DEV_IP="10.83.87.254"
	OTHERSIDE_INTERN_DEV_IP="10.83.87.253"
	INET_DEV_MASK="255.255.255.0"
	HA_DEV_MASK="255.255.255.252"
	INTERN_DEV_MASK="255.255.255.0"
	MNT="/mnt/cf/"
	MNT_DEV="/dev/sdb1"
	VPN_CONFIG_DIRECTORY="."
	OPENVPN_DIR="/etc/openvpn/"
	TUN=" tun"
	TUN8=" tun8"
	TUN9=" tun9"
	NETWORK=$(echo $INTERN_DEV_IP |sed -e 's/\.[^\.]*$//' - )
	SYSCTL="/etc/sysctl.conf"
# -d loescht /var/lib/heartbeat/crm/cib.xml.sig 
# -e0 eth0
# -e1 eth1
# -e2 eth2
# Funktionen
	function usage {
		echo "Usage: $SCRIPTNAME [-h] [-v] [-a hostname] [-b otherside_hostname] [-d] 
			[-e0 inet_dev] [-e2 HA_dev] [-e3 intern_dev] [-i0 e0_IP or dhcp]
			[-i1 e1_IP or dhcp] [-i2 e2_IP or dhcp] [-m0 i0_MASKE] [-m1 i1_MASKE]
			[-m2 i2_MASKE] [-g default_gateway] " >&2
			[[ $# -eq 1 ]] && exit $1 || exit $EXIT_FAILURE
	}
# Die Option -h fuer Hilfe sollte immer vorhanden sein, die Optionen
# -v steht fuer Verbose

while getopts ':a:b:de:f:i:k:l:vhx:yzg:' OPTION ; do
case $OPTION in
	v) VERBOSE=y
;;
	a) HOSTNAME="$OPTARG"
;;
	b) OTHERSIDE_HOSTNAME="$OPTARG"
;;
	d) REMOVE_SIG="/var/lib/heartbeat/crm/cib.xml.sig"
	FILE_HB_UUID="/var/lib/heartbeat/hb_uuid"
;;
	e) INTERN_DEV_IP="$OPTARG"
;;
	f) OTHERSIDE_INTERN_DEV_IP="$OPTARG"
;;
	g) VIRT_INTERN_DEV_IP="$OPTARG"
;;
	h) usage $EXIT_SUCCESS
;;
	i) INTERN_DEV_BROADCAST="$OPTARG"
;;
	k) VLAN253_MAC="$OPTARG"
;;
	l) VLAN254_MAC="$OPTARG"
;;
	m) MNT="$OPTARG"
;;
	x) NEW_FILE_CIB_XML="$OPTARG"
;;
	n) MNT_DEV="$OPTARG"
;;
	y) echo "gw1-bart"
	SEARCH_HOSTNAME="gw1-bart"
	SEARCH_OTHERSIDE_HOSTNAME="gw2-bart"
#	SEARCH_OTHERSIDE_IP="192.168.50.2"
#	SEARCH_INET_DEV="eth0"
#	SEARCH_HA_DEV="eth1"
#	SEARCH_INTERN_DEV="eth2"
#	SEARCH_INET_DEV_IP="192.168.7.2"
#	SEARCH_HA_DEV_IP="192.168.50.1"
	SEARCH_INTERN_DEV_IP="10.10.0.252"
	SEARCH_VIRT_INTERN_DEV_IP="10.10.0.254"
	SEARCH_INTERN_DEV_BROADCAST="10.10.0.255"
	SEARCH_OTHERSIDE_INTERN_DEV_IP="10.10.0.253"
#	SEARCH_INET_DEV_MASK="255.255.255.0"
#	SEARCH_HA_DEV_MASK="255.255.255.252"
#	SEARCH_INTERN_DEV_MASK="255.255.255.0"
;;
	z) echo "gw2-bart"
	SEARCH_HOSTNAME="gw2-bart"
	SEARCH_OTHERSIDE_HOSTNAME="gw1-bart"
#	SEARCH_OTHERSIDE_IP="192.168.50.2"
#	SEARCH_INET_DEV="eth0"
#	SEARCH_HA_DEV="eth1"
#	SEARCH_INTERN_DEV="eth2"
#	SEARCH_INET_DEV_IP="192.168.7.2"
#	SEARCH_HA_DEV_IP="192.168.50.1"
	SEARCH_INTERN_DEV_IP="10.10.0.253"
	SEARCH_VIRT_INTERN_DEV_IP="10.10.0.254"
	SEARCH_INTERN_DEV_BROADCAST="10.10.0.255"
	SEARCH_OTHERSIDE_INTERN_DEV_IP="10.10.0.252"
#	SEARCH_INET_DEV_MASK="255.255.255.0"
#	SEARCH_HA_DEV_MASK="255.255.255.252"
#	SEARCH_INTERN_DEV_MASK="255.255.255.0"
;;
	\?) echo "Unbekannte Option \"-$OPTARG\"." >&2
	usage $EXIT_ERROR
;;
	:) echo "Option \"-$OPTARG\" benoetigt ein Argument." >&2
	usage $EXIT_ERROR
;;
	*) echo "Dies kann eigentlich gar nicht passiert sein..."
	>&2
	usage $EXIT_BUG
;;
esac
done
# Verbrauchte Argumente ueberspringen
shift $(( OPTIND - 1 ))
## Eventuelle Tests auf min./max. Anzahl Argumente hier
#	if (( $# < 1 )) ; then
#	echo "Mindestens ein Argument beim Aufruf uebergeben." >&2
#	usage $EXIT_ERROR
#	fi
## Schleife ueber alle Argumente
#	for ARG ; do
#	if [[ $VERBOSE = y ]] ; then
#	echo -n "Argument: "
#	fi
#	echo $ARG
#	done

# check installed software 
SOFTWARE="sed mount chroot cp tar rm umount sync sleep"
TMP_BOOL=false
SOFT_TO_INSTALL=""
for soft in $SOFTWARE
do
	if [ ! -e $(which $soft) ]
	then
		SOFT_TO_INSTALL="$SOFT_TO_INSTALL""$soft "
		TMP_BOOL=true
	fi
done
	if [ $TMP_BOOL == true ]
	then
		echo "Please install '$SOFT_TO_INSTALL'"
		exit $EXIT_ERROR
	fi


	VPN_CONFIG_NAME="$KUNDE-$(echo $HOSTNAME |sed 's/1//; s/2//' -)"
	if [[ $VERBOSE = y ]] ; then
		echo $VPN_CONFIG_NAME
		echo $NETWORK
	fi
		mount $MNT_DEV $MNT
	if [ $? -ne 0 ]
	then
		echo "Mounten schlug fehl!" >&2
		exit $EXIT_FAILURE
	fi
	
	if [ ! -z $REMOVE_SIG ]
	then 
		rm $MNT/$REMOVE_SIG
		rm $MNT/$FILE_HB_UUID
	fi


# send_arp bug
	sed -i -e "s/255.255.0.0/255.255.255.0/g; s/10.10.255/10.10.0/g" $MNT/$FILE_INTERFACES


# sysctl bug
	sed -i -e "s/kernel.printk/#\ kernel.printk/g" $MNT/$SYSCTL

	sed -i -e "s/$SEARCH_HOSTNAME/$HOSTNAME/g; s/$SEARCH_OTHERSIDE_HOSTNAME/$OTHERSIDE_HOSTNAME/g; \
		s/$SEARCH_INTERN_DEV_IP/$INTERN_DEV_IP/g; s/$SEARCH_OTHERSIDE_INTERN_DEV_IP/$OTHERSIDE_INTERN_DEV_IP/g;\
		s/$SEARCH_VIRT_INTERN_DEV_IP/$VIRT_INTERN_DEV_IP/g; s/$SEARCH_INTERN_DEV_BROADCAST/$INTERN_DEV_BROADCAST/g;\
		s/$SEARCH_VLAN253_MAC/$VLAN253_MAC/g; s/$SEARCH_VLAN254_MAC/$VLAN254_MAC/g" $MNT/$FILE_INTERFACES

	sed -i -e "s/$SEARCH_HOSTNAME/$HOSTNAME/g; s/$SEARCH_OTHERSIDE_HOSTNAME/$OTHERSIDE_HOSTNAME/g; \
		s/$SEARCH_INTERN_DEV_IP/$INTERN_DEV_IP/g; s/$SEARCH_OTHERSIDE_INTERN_DEV_IP/$OTHERSIDE_INTERN_DEV_IP/g;\
		s/$SEARCH_VIRT_INTERN_DEV_IP/$VIRT_INTERN_DEV_IP/g; s/$SEARCH_INTERN_DEV_BROADCAST/$INTERN_DEV_BROADCAST/g;\
		" $MNT/$FILE_HOSTS

	sed -i -e "s/$SEARCH_HOSTNAME/$HOSTNAME/g; s/$SEARCH_OTHERSIDE_HOSTNAME/$OTHERSIDE_HOSTNAME/g; \
		s/$SEARCH_INTERN_DEV_IP/$INTERN_DEV_IP/g; s/$SEARCH_OTHERSIDE_INTERN_DEV_IP/$OTHERSIDE_INTERN_DEV_IP/g;\
		s/$SEARCH_VIRT_INTERN_DEV_IP/$VIRT_INTERN_DEV_IP/g; s/$SEARCH_INTERN_DEV_BROADCAST/$INTERN_DEV_BROADCAST/g;\
		" $MNT/$FILE_HOSTNAME

	sed -i -e "s/$SEARCH_NETWORK/$NETWORK/g" $MNT/$FILE_FIREWALL

	sed -i -e "s/$SEARCH_HOSTNAME/$HOSTNAME/g; s/$SEARCH_OTHERSIDE_HOSTNAME/$OTHERSIDE_HOSTNAME/g; \
		s/$SEARCH_INTERN_DEV_IP/$INTERN_DEV_IP/g; s/$SEARCH_OTHERSIDE_INTERN_DEV_IP/$OTHERSIDE_INTERN_DEV_IP/g;\
		s/$SEARCH_VIRT_INTERN_DEV_IP/$VIRT_INTERN_DEV_IP/g; s/$SEARCH_INTERN_DEV_BROADCAST/$INTERN_DEV_BROADCAST/g;\
		" $MNT/$FILE_HA_CF

	sed -i -e "s/$SEARCH_NETWORK/$NETWORK/g" $MNT/$FILE_DNSMASQ_CFG

	sed -i -e "s/$SEARCH_HOSTNAME/$HOSTNAME/g; s/$SEARCH_OTHERSIDE_HOSTNAME/$OTHERSIDE_HOSTNAME/g; \
		s/$SEARCH_INTERN_DEV_IP/$INTERN_DEV_IP/g; s/$SEARCH_OTHERSIDE_INTERN_DEV_IP/$OTHERSIDE_INTERN_DEV_IP/g;\
		s/$SEARCH_VIRT_INTERN_DEV_IP/$VIRT_INTERN_DEV_IP/g; s/$SEARCH_INTERN_DEV_BROADCAST/$INTERN_DEV_BROADCAST/g;\
		" $MNT/$FILE_SSH_CONFIG


	sed -i -e '1iStrictHostKeyChecking no\nGlobalKnownHostsFile=/dev/null\n' $MNT/$FILE_SSH_CONFIG


	if [ ! -z $NEW_FILE_CIB_XML ]
		cp $NEW_FILE_CIB_XML $MNT/$FILE_CIB
	then 
	fi


	sed -i -e "s/$SEARCH_HOSTNAME/$HOSTNAME/g; s/$SEARCH_OTHERSIDE_HOSTNAME/$OTHERSIDE_HOSTNAME/g; \
		s/$SEARCH_INTERN_DEV_IP/$INTERN_DEV_IP/g; s/$SEARCH_OTHERSIDE_INTERN_DEV_IP/$OTHERSIDE_INTERN_DEV_IP/g;\
		s/$SEARCH_VIRT_INTERN_DEV_IP/$VIRT_INTERN_DEV_IP/g; s/$SEARCH_INTERN_DEV_BROADCAST/$INTERN_DEV_BROADCAST/g;\
		" $MNT/$FILE_CIB

	rm $MNT/$OPENVPN_DIR/*.conf
	rm -rf $MNT/$OPENVPN_DIR/keys
	cp "$VPN_CONFIG_NAME"1.tar.gz $MNT/$ROOT_DIR
	cp "$VPN_CONFIG_NAME"2.tar.gz $MNT/$ROOT_DIR
	cd $MNT
	tar xvfz $MNT/$ROOT_DIR/"$VPN_CONFIG_NAME"1.tar.gz
	tar xvfz $MNT/$ROOT_DIR/"$VPN_CONFIG_NAME"2.tar.gz
	rm $MNT/$ROOT_DIR/"$VPN_CONFIG_NAME"1.tar.gz
	rm $MNT/$ROOT_DIR/"$VPN_CONFIG_NAME"2.tar.gz
	sed -i -e "s/$TUN/$TUN8/g" $MNT/$OPENVPN_DIR/"$VPN_CONFIG_NAME"1.conf
	sed -i -e "s/$TUN/$TUN9/g" $MNT/$OPENVPN_DIR/"$VPN_CONFIG_NAME"2.conf
	rm $MNT/var/lib/heartbeat/crm/*.sig
	rm $MNT/var/lib/heartbeat/crm/*.raw
	rm -rf $MNT/var/lib/heartbeat/crm/RCS
	cd
	umount $MNT_DEV
	sync
	
	exit $EXIT_SUCCESS
