  #Config VPS on UBUNTU
  
  #add user
  adduser hbq
  adduser hbq sudo
  
  # APT UPDATE
  sudo apt-get update
  
  #NODEJS
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  sudo apt-get install -y nodejs
  npm i pm2 -g
  setcap 'cap_net_bind_service=+ep' /usr/bin/node #ustawienie mozliwosci otwierania portow ponizej 1024
  
  #NGINX
  sudo apt-get install nginx -y
  
  #MYSQL
  sudo apt-get install mysql-server
  mysql_secure_installation
  mysql --user=root mysql -p
  #CREATE USER 'myuser'@'localhost' IDENTIFIED BY 'mypass';
  #GRANT ALL ON *.* TO 'myuser'@'%';
  sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf #bind-address            = 0.0.0.0
