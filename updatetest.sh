#!/bin/bash

# DEBIAN_FRONTEND を非対話型に設定
export DEBIAN_FRONTEND=noninteractive

# security updatesのリストを取得する
security_updates=$(sudo -E apt list --upgradable 2>/dev/null | grep -i security | awk -F/ '{print $1}')

if [ -z "$security_updates" ]; then
    # security updatesが無い場合
    echo "No security updates available."
else
    # security updatesがある場合はそれぞれupgrade
    for pkg in $security_updates; do
        echo "Upgrading $pkg"
        sudo -E apt-get install --only-upgrade $pkg -y -q -s    # -s is simulation、-qq は-yを含む
        # 設定ファイルを上書きする場合
        #    sudo -E apt-get install --only-upgrade $pkg -y -qq -o Dpkg::Options::="--force-confnew"
        # 以前の構成ファイルが存在する場合は新しいファイルを作成し古い構成ファイルを上書き
        #    sudo -E apt-get install --only-upgrade $pkg -y -qq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
    done
    echo "Security updates have been installed."
fi

# Chrome upgrade
sudo -E apt install --only-upgrade  google-chrome-stable -y -q -s

# Edge upgrade
sudo -E apt install --only-upgrade microsoft-edge-dev -y -q -s

# DEBIAN_FRONTEND を対話型に戻す
export DEBIAN_FRONTEND=dialog
