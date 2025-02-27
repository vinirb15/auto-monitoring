#!/bin/sh
set -e

envsubst < conf/traccar.xml.template > conf/traccar.xml

ls -l conf/

chmod 644 conf/traccar.xml

exec java -Xms1g -Xmx1g -Djava.net.preferIPv4Stack=true -jar target/tracker-server.jar conf/traccar.xml
