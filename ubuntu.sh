  #Config VPS on UBUNTU
  
  #add user
  adduser hbq
  adduser hbq sudo
  
  #nodejs
  apt-get install nodejs
  apt-get install npm
  echo "alias node=nodejs" >> /etc/profile 
  ln -s /usr/bin/nodejs /usr/bin/node
  npm i pm2 -g
  
