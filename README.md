# Docker Compose for Distributed Table

![MacDown logo](https://camo.githubusercontent.com/654284b092bd3d5b11882d4c29cc272f82e5911f/68747470733a2f2f686162726173746f726167652e6f72672f66696c65732f6439622f3036362f6536312f64396230363665363165316634383061393737643838396463303364656439392e706e67)

## Getting Started

Get docker form here [https://www.docker.com/community-edition](https://www.docker.com/community-edition).

### Some basic commands

Run `docker-compose up -d` to start services in background.

This will start the following services in the order:

* 3 Zookeeper services.
* 6 Clickhouse services.
* 1 Nginx service.

Run `docker-compose logs -f -t` to tail the logs.

Run `docker-compose down` to stop and remove services.

## Clients

### Native Client

Run `./ch_client.sh` to use the native client & connect to a clickhouse service.

### HTTP Client

You can use the plain old `curl` or a http client in any programming language to access the clickhouse services at `http://localhost:8123`

You can connect to a specific clickhouse service by using any of the following paths 

- `clickhouse_shard_1_replica_1`
- `clickhouse_shard_1_replica_2`
- `clickhouse_shard_2_replica_1`
- `clickhouse_shard_2_replica_2`
- `clickhouse_shard_3_replica_1`
- `clickhouse_shard_3_replica_2`

###### Example: 
`http://localhost:8123/clickhouse_shard_1_replica_1`

### Web

![MacDown logo](https://camo.githubusercontent.com/f56161a70041c6026f94f6a5a3f9b7bdf1f34e6f/687474703a2f2f75692e74616269782e696f2f6173736574732f696d616765732f6c6f676f74616269782e706e67)


The easiest way to get started and play with clickhouse on the web browser is to use [http://ui.tabix.io/#/login](http://ui.tabix.io/#/login)

#### Login

- name: `any name`
- host:port: `http://localhost:8123`
- user: `not required`
- password: `not required`

This connects to Nginx service. Nginx distributes the requests to the clickhouse services in a round-robin fashion.

You can connect to a specific clickhouse service by using any of the following paths 

- `clickhouse_shard_1_replica_1`
- `clickhouse_shard_1_replica_2`
- `clickhouse_shard_2_replica_1`
- `clickhouse_shard_2_replica_2`
- `clickhouse_shard_3_replica_1`
- `clickhouse_shard_3_replica_2`

###### Example:

- name: `any name`
- host:port: `http://localhost:8123/clickhouse_shard_1_replica_1`
- user: `not required`
- password: `not required`


 
## Network

All services are connected to internal network `chcompose_main` of Docker. 

### DNS

  - `zoo1`
  - `zoo2`
  - `zoo3`
  - `clickhouse_shard_1_replica_1`
  - `clickhouse_shard_1_replica_2`
  - `clickhouse_shard_2_replica_1`
  - `clickhouse_shard_2_replica_2`
  - `clickhouse_shard_3_replica_1`
  - `clickhouse_shard_3_replica_2`
  - `nginx_proxy`

## Zookeeper

To enable replication ZooKeeper is required. ClickHouse will take care of data consistency on all replicas and run restore procedure after failure automatically. This comes pre-configured so nothing to do here.

## Example Distributed Table Configuration

- You must run the following command on all the 6 clickhouse services using native client option or over http. Note that you cannot create table from TabIx as it can only be used for quering. This will create `local_table` on all the 6 services.

```
CREATE TABLE IF NOT EXISTS events 
 (
  id String,
  data String,
  created_at DateTime,
  created_at_date Date
 ) ENGINE = MergeTree(created_at_date, (id, created_at_date), 8192);
 
```

- After you've created the `local_table` on all the 6 clickhouse services you need to create the `distributed_table` on all 6 services as:

```
CREATE TABLE IF NOT EXISTS events_all AS events 
  ENGINE = Distributed(analytics, default, events, rand());
 
```

- Note that here I'm using `sharding_key` as `rand()`, which distributes the columns randomly. You can pass a `sharding_key` as well according to your business / application logic.

- Now you can insert some data using the native client. If you insert into `local_table`, data will be inserted just to single shard and replicated any node on that shard.

- If you insert into `distributed_table`, the data will be split by server and inserted into local tables on each shard of your cluster automatically. This is more convenient, but gives you less control over data distribution.

- Note that if you're going to insert data into `distributed_table` you just need to do it on a single service. Pick any one of them and connect via native client. The data is automatically distributed. No need to insert it on each service.