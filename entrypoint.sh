#!/bin/sh -e
#
# entrypoint for strongswan
#

/init.sh
exec ipsec start --nofork "$@"