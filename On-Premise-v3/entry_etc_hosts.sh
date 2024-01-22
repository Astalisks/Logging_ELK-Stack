#!/bin/bash

function add_entry_to_hosts {
    local ip=$1
    local name=$2
    local file="/etc/hosts"

    # /etc/hostsに行が存在するかどうかをgrepでチェック
    if ! grep -q "$ip $name" "$file"; then
        echo "$ip $name" | sudo tee -a "$file" > /dev/null
        echo "Added $name to $file"
    else
        echo "$name is already in $file"
    fi
}
