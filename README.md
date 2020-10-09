# Purpose

Docker container for connecting the AVM FritzBox to "virtualized" container network. 

#

```
docker-compose up -d
docker cp strongswan-fb_vpn1:/etc/ipsec.d/fbvpn.cfg .
docker-compose logs -f
```

Idea by
* https://mlohr.com/fritzbox-lan-2-lan-vpn-with-strongswan/
* https://github.com/vimagick/dockerfiles/tree/master/strongswan
