#!/bin/bash

# SIGTERM-handler
term_handler() {
  echo "Get SIGTERM"
  /etc/init.d/dnsmasq stop
  /etc/init.d/hostapd stop
  kill -TERM "$child" 2> /dev/null
}

ifconfig wlan0 10.0.0.1/24

if [ -z "$SSID" -a -z "$PASSWORD" ]; then
  ssid="Lumi X"
  password="lumilumi"
else
  ssid=$SSID
  password=$PASSWORD
fi
sed -i "s/ssid=.*/ssid=$ssid/g" /etc/hostapd/hostapd.conf
sed -i "s/wpa_passphrase=.*/wpa_passphrase=$password/g" /etc/hostapd/hostapd.conf

/etc/init.d/dbus start
/etc/init.d/hostapd start
/etc/init.d/dnsmasq start

# setup handlers
trap term_handler SIGTERM
trap term_handler SIGKILL

sleep infinity &
child=$!
wait "$child"
