#!/bin/sh

if [ ! -d /app/node_modules ];then
  cp -r /pkg/node_modules /app/node_modules
fi

exec $@
