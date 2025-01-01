#!/bin/bash

iprange=$1

if [ -z "$iprange" ]; then
    echo "Usage: $0 <iprange>"
    exit 1
fi

sudo ufw allow from $iprange