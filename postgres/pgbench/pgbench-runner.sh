#!/bin/bash

export PGDATABASE=${PGDATABASE:-pgbench-target}
export PGUSER=${PGUSER:-pgbench-user}
export PGPASSWORD=${PGPASSWORD}
export PGHOST=${PGHOST}
export PGPORT=${PGPORT}

FILL_FACTOR=${FILL_FACTOR:-100}
SCALE_FACTOR=${SCALE_FACTOR:-100}
QUERY_MODE=${QUERY_MODE:=simple}
CLIENTS=${CLIENTS:-`$(($(nproc) * 4))`}
THREADS=${THREADS:-`$(nproc)`}
DURATION_SECONDS=${DURATION_SECONDS:=300}

function check_pgbench_tables() {
  echo 'check_pgbench_tables'
  psql --set 'ON_ERROR_STOP=' <<-EOSQL
    DO \$\$
      DECLARE
        pgbench_tables CONSTANT text[] := '{ "pgbench_branches", "pgbench_tellers", "pgbench_accounts", "pgbench_history" }';
        tbl text;
      BEGIN
        FOREACH tbl IN ARRAY pgbench_tables LOOP
          IF NOT EXISTS (
            SELECT 1
            FROM pg_catalog.pg_class c
            JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
            WHERE n.nspname = 'public'
            AND c.relname = tbl
            AND c.relkind = 'r'
          ) THEN 
            RAISE EXCEPTION 'pgbench table "%" does not exist!', tbl;
          END IF;
        END LOOP;
      END 
    \$\$;
EOSQL
  psql_status=$?
  
  case $psql_status in
    0) echo "All pgbench tables exist! We can begin the benchmark" ;;
    1) echo "psql encountered a fatal error!" ;;
    2) echo "psql encountered a connection error!" ;;
    3) echo "One or more tables was missing! Initializing the database.";;
  esac

  return $psql_status
}

function initialize_pgbench_tables() {
  echo '*********** Initializing pgbench tables ************'
  echo "          - FILL_FACTOR=$FILL_FACTOR"
  echo "          - SCALE_FACTOR=$SCALE_FACTOR"
  pgbench -i -F $FILL_FACTOR -s $SCALE_FACTOR --foreign-keys
}

echo '*************** Waiting for postgres ***************'
echo '**                                                **'
echo "** PGDATABASE: ${PGDATABASE}                      **"
echo "** PGHOST:     ${PGHOST}                          **"
echo "** PGPORT:     ${PGPORT}                          **"
echo "** PGUSER:     ${PGUSER}                          **"
echo '**                                                **'
echo '****************************************************'

attempt=1
while (! pg_isready -t 1 ) && [[ $attempt -lt 100 ]]; do 
  sleep 1
done

if [[ $attempt -ge 100 ]]; then
  echo '!!!!                                          !!!!'
  echo '!!!!             BENCHMARK FAILED             !!!!'
  echo '!!!!                                          !!!!'
  echo '!!!!      postgres never became available     !!!!'
  echo '!!!!                                          !!!!'
  exit 1
fi

check_pgbench_tables
TABLE_STATUS=$psql_status
echo "TABLE_STATUS=$TABLE_STATUS"

if [[ $TABLE_STATUS -eq 3 ]]; then
  initialize_pgbench_tables
elif [[ $TABLE_STATUS -ne 0 ]]; then
  exit $TABLE_STATUS
fi

echo '***************   Running pgbench    ***************'

for run in 1 2 3; do
  echo Starting run $run
  echo "pgbench -c $CLIENTS -j $THREADS -M $QUERY_MODE -s $SCALE_FACTOR -T $DURATION_SECONDS"
  pgbench -c $CLIENTS -j $THREADS -M $QUERY_MODE -s $SCALE_FACTOR -T $DURATION_SECONDS
  echo
  echo
done
