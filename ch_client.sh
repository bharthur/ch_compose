#!/bin/bash

echo "Select a server:";

select choice in \
  "Shard 1 Replica 1" \
  "Shard 1 Replica 2" \
  "Shard 2 Replica 1" \
  "Shard 2 Replica 2" \
  "Shard 3 Replica 1" \
  "Shard 3 Replica 2"; 
do
case "$choice" in
    "Shard 1 Replica 1") echo "Connecting to $choice ..."; docker container run -it --rm --network chcompose_main \
       --link chcompose_clickhouse_shard_1_replica_1_1:clickhouse-server yandex/clickhouse-client \
       --host clickhouse-server 
    break;;
    "Shard 1 Replica 2") echo "Connecting to $choice ..."; docker container run -it --rm --network chcompose_main \
       --link chcompose_clickhouse_shard_1_replica_2_1:clickhouse-server yandex/clickhouse-client \
       --host clickhouse-server 
    break;;
    "Shard 2 Replica 1") echo "Connecting to $choice ..."; docker container run -it --rm --network chcompose_main \
       --link chcompose_clickhouse_shard_2_replica_1_1:clickhouse-server yandex/clickhouse-client \
       --host clickhouse-server 
    break;;
    "Shard 2 Replica 2") echo "Connecting to $choice ..."; docker container run -it --rm --network chcompose_main \
       --link chcompose_clickhouse_shard_2_replica_2_1:clickhouse-server yandex/clickhouse-client \
       --host clickhouse-server 
    break;;
    "Shard 3 Replica 1") echo "Connecting to $choice ..."; docker container run -it --rm --network chcompose_main \
       --link chcompose_clickhouse_shard_3_replica_1_1:clickhouse-server yandex/clickhouse-client \
       --host clickhouse-server 
    break;;
    "Shard 3 Replica 2") echo "Connecting to $choice ..."; docker container run -it --rm --network chcompose_main \
       --link chcompose_clickhouse_shard_3_replica_2_1:clickhouse-server yandex/clickhouse-client \
       --host clickhouse-server 
    break;;
    *) echo "Error: Please try again (select 1..6)!"
    ;;
esac
done