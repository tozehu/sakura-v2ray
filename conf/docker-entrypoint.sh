#!/bin/sh

if [ ! -d /app/node_modules ];then
  cp  /tmp/pkg/node_modules /app/node_modules
fi

exec $@
