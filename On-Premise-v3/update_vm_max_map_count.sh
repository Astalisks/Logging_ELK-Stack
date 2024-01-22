#!/bin/bash

function update_vm_max_map_count {
    local desired_value=262144

    # 現在のvm.max_map_countの値を取得
    local current_value=$(sysctl -n vm.max_map_count)

    # 現在の値と目的の値を比較
    if [ "$current_value" != "$desired_value" ]; then
        # 値が異なる場合は、/etc/sysctl.confに設定を追加
        echo "vm.max_map_count=$desired_value" | sudo tee -a /etc/sysctl.conf
        # システム設定を更新
        sudo sysctl -p
        echo "vm.max_map_count has been updated to $desired_value"
    else
        echo "vm.max_map_count is already set to $desired_value"
    fi
}
