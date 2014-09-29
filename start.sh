#!/bin/bash

#Define app defaults
if [[ -z "$NAME" ]] ; then
  NAME=$HOSTNAME
fi

if [[ -z "$PORT" ]] ; then
  PORT=55555
fi

if [[ -z "$USER" ]] ; then
  USER='admin'
fi

if [[ -z "$PASS" ]] ; then
  #Random hard pass if not defined
  PASS=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c 32 | base64)
fi

if [[ -z "$SECRET" ]] ; then
  #Generate super strong random rw-secret to start with
  SECRET="$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c 250 | tr -d ' ' | base64)"
  SECRET=$(echo $SECRET | tr -d ' ')
  READONLY=$(btsync --get-ro-secret $SECRET)
fi

if [[ -z "$SYNCDIR" ]] ; then
  SYNCDIR='/data'
fi

echo "Starting btsync..."
#CHOOSE IF IT'S VOLUME OR UI
#Grep config files so we only do the replacing once.
if [[ "$TYPE" == "VOLUME" ]] ; then
  cp config-volume config
  if grep -q NAME config; then
    sed -i -e "s|SECRET|$SECRET|g" config
    sed -i -e "s|SYNCDIR|$SYNCDIR|g" config
    sed -i -e "s|NAME|$NAME|g" config
    sed -i -e "s|PORT|$PORT|g" config
    echo "Yay I'm running! You can copy me with these:
      SECRET:$SECRET
      READONLY:$READONLY
      NAME:$NAME
      PORT:$PORT
      "
  fi
else #It's UI
  #Start the container with UI.
  cp config-ui config
  if grep -q NAME config; then
    sed -i -e "s|PASS|$PASS|g" config
    sed -i -e "s|USER|$USER|g" config
    sed -i -e "s|NAME|$NAME|g" config
    sed -i -e "s|PORT|$PORT|g" config
    echo "Yay I'm running! You can login with these:
      USER:$USER
      PASS:$PASS
      NAME:$NAME
      PORT:$PORT
      "
  fi
fi
echo "Debug my config:"
cat config
echo ""

btsync --config config --nodaemon