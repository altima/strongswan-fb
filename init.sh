#!/bin/sh -e
#
# gen config files for strongswan
#
# - SERVER_FQDN
# - SERVER_SUBNET
# - FB_FQDN
# - FB_NET
# - VPN_PSK
#

if [ -e /etc/ipsec.d/ipsec.conf ]
then
    echo "Initialized!"
    exit 0
else
    echo "Initializing..."
fi

cat > /etc/ipsec.d/ipsec.conf <<_EOF_
config setup

conn fb
  keyexchange=ikev1
  aggressive=yes
  ike=aes256-sha1-modp1024
  esp=aes256-sha1-modp1024
  left=${SERVER_IP}
  leftid="@${SERVER_FQDN}"
  leftsubnet=${SERVER_NET}/24
  leftauth=psk
  right=${FB_FQDN}
  rightsubnet=${FB_NET}/24
  rightauth=psk
  dpdaction=restart
  dpddelay=60s
  dpdtimeout=300s
  auto=start
  closeaction=restart
_EOF_


cat > /etc/ipsec.d/ipsec.secrets <<_EOF_
@${SERVER_FQDN} @${FB_FQDN} : PSK "${VPN_PSK}"
_EOF_

#cat > /etc/strongswan.d/charon.conf <<_EOF_
#charon {
#	i_dont_care_about_security_and_use_aggressive_mode_psk = yes
#}
#_EOF_

# gen config for fritzbox

cat > /etc/ipsec.d/fbvpn.cfg <<_EOF_
vpncfg {
        connections {
                enabled = yes;
                conn_type = conntype_lan;
                name = "${SERVER_FQDN}";
                always_renew = yes;
                reject_not_encrypted = no;
                dont_filter_netbios = yes;
                localip = 0.0.0.0;
                local_virtualip = 0.0.0.0;
                remoteip = 0.0.0.0;
                remote_virtualip = 0.0.0.0;
                remotehostname = "${SERVER_FQDN}";
                localid {
                        fqdn = "${FB_FQDN}";
                }
                remoteid {
                        fqdn = "${SERVER_FQDN}";
                }
                mode = phase1_mode_idp;
                phase1ss = "all/all/all";
                keytype = connkeytype_pre_shared;
                key = "${VPN_PSK}";
                cert_do_server_auth = no;
                use_nat_t = yes;
                use_xauth = no;
                use_cfgmode = no;
                phase2localid {
                        ipnet {
                                ipaddr = ${FB_NET};
                                mask = 255.255.255.0;
                        }
                }
                phase2remoteid {
                        ipnet {
                                ipaddr = ${SERVER_NET};
                                mask = 255.255.255.0;
                        }
                }
                phase2ss = "esp-all-all/ah-none/comp-all/pfs";
                accesslist = "permit ip any ${SERVER_NET} 255.255.255.0";
        }
        ike_forward_rules = "udp 0.0.0.0:500 0.0.0.0:500", 
                            "udp 0.0.0.0:4500 0.0.0.0:4500";
}
_EOF_