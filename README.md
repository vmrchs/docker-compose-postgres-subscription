# PostgreSQL Logical Replication Setup

This repository demonstrates setting up logical replication between PostgreSQL instances using Docker Compose.

## Overview

The setup consists of two PostgreSQL containers:

- `pg_master`: Primary database where data is written
- `pg_replica`: Replica database that mirrors data from the master

Logical replication allows you to replicate specific tables rather than entire databases and supports replication between different PostgreSQL versions.

## Repository Contents

- `docker-compose.yaml`: Defines the PostgreSQL containers
- `init-scripts/master-init.sql`: Initializes the master database with tables and sample data
- `init-scripts/replica-init.sql`: Initializes the replica database with table structure only
- `setup-replication.sh`: Script to set up the replication between instances

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/vmrchs/postgres-replication-demo.git
cd postgres-replication-demo
```

### 2. Start the containers

```bash
docker-compose up -d
```

This will start both PostgreSQL containers. The master will be configured with logical replication enabled and will create the necessary table and sample data. The replica will only create the table structure.

### 3. Set up replication

After both containers are running, execute the setup script:

```bash
./setup-replication.sh
```

This script will:

1. Wait for both databases to be ready
2. Create a subscription on the replica to connect to the master
3. Begin replicating data from the master to the replica

## Testing the Replication

1. Connect to the master database:

```bash
docker exec -it pg_master psql -U postgres -d testdb
```

2. Insert new data:

```sql
INSERT INTO orders (product_name, quantity, order_date) VALUES ('Monitor', 1, '2025-04-01');
```

3. Connect to the replica database and verify that the data was replicated:

```bash
docker exec -it pg_replica psql -U postgres -d testdb
```

```sql
SELECT * FROM orders;
```

You should see all the data, including the new "Monitor" record.

## Troubleshooting

If replication isn't working:

1. Check that both containers are running:

```bash
docker ps
```

2. Check logs for any errors:

```bash
docker logs pg_master
docker logs pg_replica
```

3. Verify network connectivity between containers:

```bash
docker exec pg_replica ping pg_master
```

4. Check replication status on the replica:

```bash
docker exec -it pg_replica psql -U postgres -d testdb -c "SELECT * FROM pg_stat_subscription;"
```

## Environment Configuration

The PostgreSQL instances are configured with the following settings:

- Database name: `testdb`
- Username: `postgres`
- Password: `postgres123`
- Master port: `5432` (mapped to host)
- Replica port: `5433` (mapped to host)

You can modify these settings in the `docker-compose.yaml` file if needed.

## Additional Resources

- [PostgreSQL Logical Replication Documentation](https://www.postgresql.org/docs/current/logical-replication.html)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
