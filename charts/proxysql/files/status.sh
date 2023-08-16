#!/bin/bash

set -u

echo "From stats:"
mysql -h 127.0.0.1 -P6032 -uadmin -padmin -e "select hostgroup,srv_host,status,ConnUsed,MaxConnUsed,Queries,Latency_us from stats.stats_mysql_connection_pool order by hostgroup, srv_host;"

echo "From runtime:"
mysql -h 127.0.0.1 -P6032 -uadmin -padmin -e "select hostgroup_id, hostname, port, gtid_port, status, weight from runtime_mysql_servers;"

echo "From ping log:"
mysql -h 127.0.0.1 -P6032 -uadmin -padmin -e "select hostname, ping_success_time_us, ping_error from monitor.mysql_server_ping_log order by time_start_us desc limit 3;"
