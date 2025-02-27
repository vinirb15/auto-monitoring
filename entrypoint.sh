#!/bin/sh
set -e

envsubst < conf/default.xml > conf/traccar.xml

chmod 644 conf/traccar.xml

exec java -Xms1g -Xmx1g -Djava.net.preferIPv4Stack=true -jar target/tracker-server.jar conf/traccar.xml
