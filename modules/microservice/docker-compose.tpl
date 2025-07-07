#!/bin/bash
exec > >(tee /dev/tty) 2>&1
set -x
apt update -y
apt install -y docker.io curl
curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

cat <<EOL > /home/ubuntu/docker-compose.yml
version: '3'
services:
  product-create:
    image: ${image_user_create}
    ports:
      - "${port_user_create}:6000"
    environment:
      - PORT=6000
      - DB_CONNECTION=${db_connection}
      - DB_HOST=${db_host}
      - DB_PORT=${db_port}
      - DB_DATABASE=${db_database}
      - DB_USERNAME=${db_username}
      - DB_PASSWORD=${db_password}
  product-read:
    image: ${image_user_read}
    ports:
      - "${port_user_read}:6001"
    environment:
      - PORT=6001
      - DB_CONNECTION=${db_connection}
      - DB_HOST=${db_host}
      - DB_PORT=${db_port}
      - DB_DATABASE=${db_database}
      - DB_USERNAME=${db_username}
      - DB_PASSWORD=${db_password}
  product-update:
    image: ${image_user_update}
    ports:
      - "${port_user_update}:6002"
    environment:
      - PORT=6002
      - DB_CONNECTION=${db_connection}
      - DB_HOST=${db_host}
      - DB_PORT=${db_port}
      - DB_DATABASE=${db_database}
      - DB_USERNAME=${db_username}
      - DB_PASSWORD=${db_password}
  product-delete:
    image: ${image_user_delete}
    ports:
      - "${port_user_delete}:6003"
    environment:
      - PORT=6003
      - DB_CONNECTION=${db_connection}
      - DB_HOST=${db_host}
      - DB_PORT=${db_port}
      - DB_DATABASE=${db_database}
      - DB_USERNAME=${db_username}
      - DB_PASSWORD=${db_password}
EOL

systemctl start docker
systemctl enable docker
cd /home/ubuntu
docker-compose up -d
