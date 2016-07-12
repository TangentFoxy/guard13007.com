This file is essentially notes and commands to run to set this server up.

1. Create an Ubuntu server, latest LTS version.

2. Point DNS at the correct IP (it should be an A Record with an `@` symbol).

2. Install basics:
   ```bash
   apt-get update
   apt-get install screen
   screen
   apt-get install nginx tree
   apt-get install letsencrypt      # might not work?
   apt-get install wget curl nano   # these should already be installed
   ```

3. Set up certificate(s):
   ```bash
   nginx -s stop
   letsencrypt certonly --standalone -m paul.liverman.iii@gmail.com -d www.guard13007.com -d guard13007.com
   #wget https://dl.eff.org/certbot-auto
   #chmod a+x ./certbot-auto
   #./certbot-auto
   # continue as above, but with ./certbot-auto
   ```

5. Setup NGINX as a proxy. (todo: ref modified version somewhere)

6. Install OpenResty/LuaRocks/Lapis/etc:
   ```bash
   apt-get install lua5.1 liblua5.1-0-dev zip unzip libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential postgresql
   wget https://keplerproject.github.io/luarocks/releases/luarocks-2.3.0.tar.gz   # check for a new version first!
   tar xvf luarocks-2.3.0.tar.gz
   cd luarocks-2.3.0
   ./configure
   make build
   make install
   luarocks install lapis
   luarocks install moonscript
   cd ..
   wget https://openresty.org/download/openresty-1.9.7.5.tar.gz   # check for a new version first!
   tar xvf openresty-1.9.7.5.tar.gz
   cd openresty-19.7.5
   ./configure
   make
   make install
   cd ..
   ```

7. Clone the repo, set the server to automatically start when the server goes online:
   ```
   git clone https://github.com/Guard13007/guard13007.com.git
   cd guard13007.com
   cp ./secret.moon.example ./secret.moon
   nano ./secret.moon                       # fix the secrets!
   moonc .
   lapis migrate production
   lapis server production
   # DO THE AUTO SHIT HERE
   # TODO FIGURE OUT HOW DO REST
   ```
