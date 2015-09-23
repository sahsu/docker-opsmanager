[![](https://badge.imagelayers.io/sahsu/docker-opsmanager:latest.svg)](https://imagelayers.io/?images=sahsu/docker-opsmanager:latest 'Get your own badge on imagelayers.io')
# MongoDB Ops Manager for docker
- [Intro](#Intro)
  - [Version](#Version)
  - [ChangeLog](Changelog.md)
- [Prerequisites](#Prerequisites)
- [Installation](#Installation)
- [QuickStart](#QuickStart)
- [Configure](#Configure)
  - [Database](#Database)
- [Maintenance](#Maintenance)
- [Referenace](#Referance)

# Intro
  Dockerfile / Docker-compose file to build a MongoDB Ops Manager container image.
## Version
  Currently Version: `1.8.1.290-1`
# Prerequisites
  1. Please check [Ops Manager Installation Guide](https://docs.opsmanager.mongodb.com/current/installation/) for avoid time wasting specialy [Ops Manager Hardware and Software Requirements](https://docs.opsmanager.mongodb.com/current/core/requirements/)
  1. 4+ Core / 16G Memory will prefer - use m4.xlarge as default.
  
# Installation
  1. you should get ready on docker install on your hosts and run 

  ```bash
  docker run --name opsmanager -d sahsu/opsmanager
  ```
  1. it will (1) pull sahsu/opsmanager from Docker Hub (2) run it as background.
  1. and waiting for 3 - 5 mins ( depends on your instance type ) and open `http://{YOUR_DOCKER_HOST_IP}:{YOUR_OPSMANAGER_PORT}`
  2. default port - 8080 and you can add -p 18080:8080 on docker run command to change your port.

# QuickStart
  1. after you run docker images and waiting for 3 - 5 mins you can open browser to open your ops manager - `http://{YOUR_DOCKER_HOST_IP}:{YOUR_OPSMANAGER_PORT}`
  2. for default configure the mongodb for application and backup will running on same instance so you don't need to do anything configure update, for separe Mongodb please check on [Configure](#Configure)

# Configure
  1. Ops Manager designed to serverless means your app is only app, all data is stored on Application MongoDB
  2. By default, if you don't assign **OPSMANAGER_MONGO_APP** then script will create two mongo in local running with port : 27017 & 27018
  1. if you are going to manually deploy Ops Manger with 2 mongo you can use sample code:

  ```bash
  sudo docker run --name appmongo -d mongo:3
  sudo docker run --name backupmongo -d mongo:3
  sudo docker run --name opsmanager \
     --link appmongo:appmongo \
     --link backupmongo:backupmongo \
     -p 18080:8080 \
     -e 'OPSMANAGER_MONGO_APP=appmongo:27017' \
     -e 'OPSMANAGER_BACKUPMONGO=backupmongo:27017' \
     -e 'OPSMANAGER_CENTRALUR=10.23.10.114' \
     -e 'OPSMANAGER_CENTRALURLPORT=18080' \
     sahsu/docker-opsmanager bash
  ```

## Each Env means
  - **OPSMANAGER_CFG**: the main ops manager cfg, you should keep this are same.
  - **OPSMANAGER_BACKUPCFG**: same as **OPSMANAGER_CFG**.
  - **OPSMANAGER_MONGO_APP**: application mongodb URI & Port, default use loaclhost:27017.
  - **OPSMANAGER_CENTRALURL**: default ops manager URI, change it to your FQDN.
  - **OPSMANAGER_CENTRALURLPORT**: default ops manager URI port, change it your port.
  - **OPSMANAGER_BACKUPURL**: default ops manager backup url, should same as **OPSMANAGER_CENTRALURL**.
  - **OPSMANAGER_BACKUPURLPORT**: default ops manager backup url port
  - **OPSMANAGER_FROMEMAIL**: default ops manager from email
  - **OPSMANAGER_ADMINEMAIL**: default ops manager admin email
  - **OPSMANAGER_REPLYTOEMAIL**: default reply email
  - **OPSMANAGER_ADMINFROMEMAIL**: default admin from email
  - **OPSMANAGER_BOUNCEEMAIL**: default bounce email
  - **OPSMANAGER_APPLOG**: default log path
  - **OPSMANAGER_BACKUPLOG**: default backup log path
  - **OPSMANAGER_BACKUPMONGO**: default backup mongo URI ( should same as **OPSMANAGER_MONGO_APP** )
  - **OPSMANAGER_BACKUPPATH**: default backup daemon storage databse path

## Database
  1. You can use `docker-compose.yml` to quick start up with app x 1 mongodb x 2 ( for app & backup purpose )

  ```bash
  cd to docker-opsmanager/
  sudo docker-compose up
  ```
  2. and you can check on (docker-compose.yml) for more detail information and made your docker-compose configure file.

# Maintenance
  - ** app:start **: start Ops Manager, default action
  - ** bash **: start bash, run it with `docker run -it` you can enter bash and run `/sbin/entrypoint.sh` for see manually startups Ops Manager.


# Referenace
  1. [Ops Manager newest Manual](https://docs.opsmanager.mongodb.com/current/)
  2. [Ops Manager Release note](https://docs.opsmanager.mongodb.com/current/release-notes/application/)
  3. [Ops Manager Download link](https://www.mongodb.com/lp/download/mongodb-enterprise)
