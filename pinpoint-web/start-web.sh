#!/bin/bash
set -e
set -x

CLUSTER_ENABLE=${CLUSTER_ENABLE:-false}

ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin}

HBASE_HOST=${HBASE_HOST:-localhost}
HBASE_PORT=${HBASE_PORT:-2181}

DISABLE_DEBUG=${DISABLE_DEBUG:-true}
DISABLE_ANALYTICS=${DISABLE_ANALYTICS:-true}

JDBC_DRIVER=${JDBC_DRIVER:-com.mysql.jdbc.Driver}
JDBC_URL=${JDBC_URL:-jdbc:mysql://mysql:3306/pinpoint?characterEncoding=UTF-8}
JDBC_USERNAME=${JDBC_USERNAME:-admin}
JDBC_PASSWORD=${JDBC_PASSWORD:-admin}

cp /assets/pinpoint-web.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/pinpoint-web.properties
cp /assets/hbase.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/hbase.properties

sed -i "s/cluster.enable=true/cluster.enable=${CLUSTER_ENABLE}/g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/pinpoint-web.properties

sed -i "s/admin.password=admin/admin.password=${ADMIN_PASSWORD}/g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/pinpoint-web.properties

sed -i "s/hbase.client.host=localhost/hbase.client.host=${HBASE_HOST}/g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/hbase.properties
sed -i "s/hbase.client.port=2181/hbase.client.port=${HBASE_PORT}/g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/hbase.properties


sed -i "s/jdbc.url=jdbc.*$/jdbc.url=${JDBC_URL}/g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/jdbc.properties
sed -i "s/jdbc.username=.*$/jdbc.username=${JDBC_USERNAME}/g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/jdbc.propertie
sed -i "s/jdbc.password=.*$/jdbc.password=${JDBC_PASSWORD}/g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/jdbc.propertie


if [ "$DISABLE_DEBUG" == "true" ]; then
    sed -i 's/level value="DEBUG"/level value="INFO"/' /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/log4j.xml
fi

if [ "$DISABLE_ANALYTICS" == "true" ]; then
    sed -i 's/config.sendUsage.*/config.sendUsage=false/' /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/pinpoint-web.properties
fi

exec /usr/local/tomcat/bin/catalina.sh run
