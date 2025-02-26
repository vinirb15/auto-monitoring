#!/bin/sh
set -e

envsubst < /app/conf/traccar.xml.template > /app/conf/traccar.xml

chmod 644 /app/conf/traccar.xml

exec java -Xms1g -Xmx1g -Djava.net.preferIPv4Stack=true -jar /app/target/tracker-server.jar /app/conf/traccar.xml
