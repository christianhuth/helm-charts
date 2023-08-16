#!/bin/bash

set -u

# This assumes hostgroup id 1 as the default writer hostgroup - and in case of Galera, writer_is_also_reader=1‚
COUNT=$(mysql -h 127.0.0.1 -P6032 -uadmin -padmin --batch --skip-column-names -e "select count(hostname) > 0 from runtime_mysql_servers where status = 'ONLINE' and hostgroup_id = 1;")
if [[ $COUNT -gt 0 ]]; then
  exit 0
else
  exit 1
fi
