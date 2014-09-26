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

echo "Yay I'm running! You can login with these:
USER:$USER
PASS:$PASS
"

sed -i -e "s/PASS/$PASS/g" config
sed -i -e "s/USER/$USER/g" config
sed -i -e "s/NAME/$NAME/g" config

# In case the directory was synced before with another SyncID
rm $1/.SyncID
btsync --config config --nodaemon