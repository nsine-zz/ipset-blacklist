#!/bin/bash
#
# usage update-whitelist.sh <configuration file>
# eg: update-whitelist.sh /etc/ipset-blacklist/ipset-whitelist.list
#

IPSET_BLACKLIST_NAME=blacklist

function exists() { command -v "$1" >/dev/null 2>&1 ; }

if [[ -z "$1" ]]; then
  echo "Error: please specify a file, e.g. $0 /etc/ipset-blacklist/ipset-whitelist.list"
  exit 1
fi

# shellcheck source=ipset-whitelist.list
#if ! source "$1"; then
#  echo "Error: can't load file $1"
#  exit 1
#fi

if ! exists curl && exists egrep && exists grep && exists ipset && exists iptables && exists sed && exists sort && exists wc ; then
  echo >&2 "Error: searching PATH fails to find executables among: curl egrep grep ipset iptables sed sort wc"
  exit 1
fi


while IFS="" read -r IP_WHITELIST || [ -n "$IP_WHITELIST" ]
do
  ipset del $IPSET_BLACKLIST_NAME $IP_WHITELIST
done < $1
