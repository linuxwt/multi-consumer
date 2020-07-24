FROM 192.168.0.152:8082/soa-maven-jdk:v1
ADD target/*jar /tmp/
WORKDIR /tmp

CMD java -jar $(ls *.jar)
