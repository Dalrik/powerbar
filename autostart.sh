#!/usr/bin/sh

PROP=autostart.wasrun
HASPROP=$(xrdb -query|grep $PROP)

if [ "$HASPROP" != "" ]
then
    exit 0;
fi

TEMPLATE=xsession-$USER-$PPID-XXX
TEMPFILE=$(mktemp --tmpdir $TEMPLATE)

echo "logging to $TEMPFILE"

echo "$PROP: on" | xrdb -merge

xrdb -merge ~/.XResources

( /usr/bin/dex -v -a -e AWESOME 2>&1 1>$TEMPFILE ) &
