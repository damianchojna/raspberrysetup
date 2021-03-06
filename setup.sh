########################################################
# SETUP DATE
########################################################
TIMEZONE="Europe/Warsaw"

sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime
sudo rm /etc/timezone
echo $TIMEZONE | sudo tee /etc/timezone

########################################################
# Fixing Raspberry Pi Wifi from Dropping
########################################################
if [ -f /etc/ifplugd/action.d/ifupdown ]; then
    echo "Backup /etc/ifplugd/action.d/ifupdown.original"
    sudo mv /etc/ifplugd/action.d/ifupdown /etc/ifplugd/action.d/ifupdown.original
fi
if [ ! -f /etc/ifplugd/action.d/ifupdown ]; then
    echo "Add action /etc/ifplugd/action.d/ifupdown"
    sudo cp /etc/wpa_supplicant/ifupdown.sh /etc/ifplugd/action.d/ifupdown
fi

########################################################
# Install Packages
########################################################
apt-get update
apt-get install vim -y
apt-get install git -y
apt-get install nginx -y
apt-get install screen -y
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
#dla pm2
sudo apt-get pm2 -g
sudo pm2 startup systemd -u pi

#Graphana - do not work
#sudo apt update 
#sudo apt upgrade -y
#sudo apt autoremove -y
#sudo apt --fix-broken install
#sudo apt-get install adduser libfontconfig
#wget https://dl.grafana.com/oss/release/grafana_5.4.0_armhf.deb
#sudo dpkg -i grafana_5.4.0_armhf.deb
#sudo apt-get upgrade
#sudo /bin/systemctl daemon-reload
#sudo /bin/systemctl enable grafana-server
#sudo /bin/systemctl start grafana-server

#Grafana and influx easy way
wget --no-check-certificate  https://bitbucket.org/api/2.0/snippets/scargill/qexexb/master/files/script.sh

#INFLUX
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
echo "deb https://repos.influxdata.com/debian stretch stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sudo apt update
sudo apt install influxdb  
sudo systemctl enable influxdb
sudo systemctl start influxdb 
influx

#SAMBA
sudo apt-get install samba samba-common-bin
#dodajemy naszego użytkownika(w miejsce pi wpisz swoją nazwę) i podajemy hasło wymagane do zalogowania się na nasz dysk sieciowy.
sudo smbpasswd -a pi
#na wszelki wypadek wykonujemy kopię zapasową pliku konfiguracyjnego
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.old
# W Sekcji Authentication usuwamy # sprzed security = user. 
# Jeśli chcemy móc coś wysyłać do RPi, a nie tylko pobierać, to w sekcji [homes] zmieniamy read only = yes na read only = no.
#Kolejnym etapem jest dodanie folderów lub dysków, które mają być udostępnione.
sudo vim /etc/samba/smb.conf

[public]
comment = Public Storage
path = /home/public
valid users = @users
force group = users
create mask = 0660
directory mask = 0771
read only = no

#restartujemy serwer Samby.
sudo /etc/init.d/samba restart


#Node.js
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt install -y nodejs

#Influx
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
echo "deb https://repos.influxdata.com/debian buster stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sudo apt-get update && sudo apt-get install influxdb
sudo service influxdb start
