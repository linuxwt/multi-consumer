#!/bin/bash

ssh root@192.168.0.150 'cd /root/docker/consumer && docker stack deploy -c docker-compose.yml 150'
