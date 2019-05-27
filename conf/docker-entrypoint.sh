#!/bin/sh

if [ ! -d /app/node_modules ];then
  cp  /pkg/node_modules /app/node_modules
fi

exec $@
