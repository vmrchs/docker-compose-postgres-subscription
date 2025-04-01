#!/bin/bash
# setup-replication.sh

# Wait for master to be ready
until docker exec pg_master pg_isready -U postgres; do
  echo "Waiting for master database..."
  sleep 1
done

# Wait for replica to be ready
until docker exec pg_replica pg_isready -U postgres; do
  echo "Waiting for replica database..."
  sleep 1
done

# Create the subscription on the replica
docker exec pg_replica psql -U postgres -d testdb -c "
CREATE SUBSCRIPTION orders_sub 
CONNECTION 'host=pg_master port=5432 dbname=testdb user=postgres password=postgres123'
PUBLICATION orders_pub;
"

echo "Replication setup complete!"