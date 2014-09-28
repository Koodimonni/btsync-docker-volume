#!/bin/bash

#Define app defaults
if [[ -z "$NAME" ]] ; then
  NAME=$HOSTNAME
fi

if [[ -z "$USER" ]] ; then
  USER='admin'
fi

if [[ -z "$PASS" ]] ; then
  #Random hard pass if not defined
  PASS=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
fi

#Only do the replacing once.
if grep -q PASS config; then
  sed -i -e "s/PASS/$PASS/g" config
  sed -i -e "s/USER/$USER/g" config
  sed -i -e "s/NAME/$NAME/g" config
  echo "Yay I'm running! You can login with these:
    USER:$USER
    PASS:$PASS
    "
fi

btsync --config config --nodaemon