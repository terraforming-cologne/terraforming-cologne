#!/bin/bash

set -eu

timestamp=$(date +"%Y-%m-%d_%H-%M")
backup_dir="/backup"
repo="backup:/home/backup"

mkdir -p "$backup_dir"

borg_backup() {
  local name="$1"
  shift
  local paths=("$@")

  borg create "${repo}/${name}::${timestamp}" "${paths[@]}"
  borg prune --keep-hourly 12 --keep-daily 14 "${repo}/${name}"
  borg compact "${repo}/${name}"
}

backup_terraforming-cologne() {
  local container
  container=$(docker ps --format "{{.ID}} {{.Names}}" | grep "terraforming-cologne-web" | awk '{print $1}')

  local sql_main="${backup_dir}/terraforming-cologne.sql"
  local sql_cable="${backup_dir}/terraforming-cologne_cable.sql"
  local sql_cache="${backup_dir}/terraforming-cologne_cache.sql"
  local sql_queue="${backup_dir}/terraforming-cologne_queue.sql"

  docker exec -t $container sqlite3 /rails/storage/production.sqlite3 .dump > "$sql_main"
  docker exec -t $container sqlite3 /rails/storage/production_cable.sqlite3 .dump > "$sql_cable"
  docker exec -t $container sqlite3 /rails/storage/production_cache.sqlite3 .dump > "$sql_cache"
  docker exec -t $container sqlite3 /rails/storage/production_queue.sqlite3 .dump > "$sql_queue"

  borg_backup "terraforming-cologne" \
    "$sql_main" \
    "$sql_cable" \
    "$sql_cache" \
    "$sql_queue" \
    "/var/lib/docker/volumes/terraforming_cologne_storage/_data"
}

backup_terraforming-cologne

rm -f "${backup_dir:?}/"*
