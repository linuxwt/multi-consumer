#!/bin/bash

jarfile=$(echo $(ls target/*jar) | awk -F '/' '{print $2}')
jarname=${jarfile%.*}
tag=${jarname#*-}
cat <<EOF>>  docker-compose.yml
version: "3.4"
services:
  consumer:
    image: 192.168.0.152:8082/com.teng-consumer:$tag
    networks:
      - service_overlay
      - monitor_overlay
      - database_overlay
      - elk_overlay
    ports:
      - 8084:8084
    volumes:
      -  "/etc/localtime:/etc/localtime:ro"
    deploy:
      placement:
        constraints: [node.hostname==node150]
      restart_policy:
        condition: any
        delay: 5s
        max_attempts: 3
networks:
  service_overlay:
    external: true
  monitor_overlay:
    external: true
  database_overlay:
    external: true
  elk_overlay:
    external: true
EOF
scp docker-compose.yml root@192.168.0.150:/root/docker/consumer
ssh root@192.168.0.150 'cd /root/docker/consumer &&  docker stack deploy -c docker-compose.yml --prune  150'
