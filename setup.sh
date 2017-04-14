#SETUP DATE
TIMEZONE="Europe/Warsaw"

sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime
sudo rm /etc/timezone
echo $TIMEZONE | sudo tee /etc/timezone

apt-get install vim -y
apt-get install git -y

#Fixing Raspberry Pi Wifi from Dropping
if [ -f /etc/ifplugd/action.d/ifupdown ]; then
    echo "Backup /etc/ifplugd/action.d/ifupdown.original"
    sudo mv /etc/ifplugd/action.d/ifupdown /etc/ifplugd/action.d/ifupdown.original
fi
if [ ! -f /etc/ifplugd/action.d/ifupdown ]; then
    echo "Add action /etc/ifplugd/action.d/ifupdown"
    sudo cp /etc/wpa_supplicant/ifupdown.sh /etc/ifplugd/action.d/ifupdown
fi

#NODEJS
if ! type node >/dev/null; then
    MACHINE=$(uname -m)
    NODE_VERSION="6.10.2"
    NODE_FILE=node-v$NODE_VERSION-linux-$MACHINE
    wget https://nodejs.org/dist/v$NODE_VERSION/$NODE_FILE.tar.xz
    tar -xvf $NODE_FILE.tar.xz
    cd $NODE_FILE
    sudo cp -R bin/ /usr/local/
    sudo cp -R include /usr/local/
    sudo cp -R lib/ /usr/local/
    sudo cp -R share/ /usr/local/
    cd -
    rm $NODE_FILE.tar.xz
    rm -rf $NODE_FILE
    echo "Nodejs installed"
    node --version
fi
