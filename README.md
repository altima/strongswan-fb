# Purpose

Docker container for connecting the AVM FritzBox to "virtualized" container network. 

#

```
docker-compose up -d
docker cp strongswan-fb_vpn1:/etc/ipsec.d/client.mobileconfig .
docker cp strongswan_strongswan_1:/etc/ipsec.d/client.cert.p12 .
docker-compose logs -f
```

Idea by
* https://mlohr.com/fritzbox-lan-2-lan-vpn-with-strongswan/
* https://github.com/vimagick/dockerfiles/tree/master/strongswan
