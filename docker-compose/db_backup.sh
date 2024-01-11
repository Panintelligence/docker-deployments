#!/bin/bash
# Takes a backup of the maria db data and drops it into the backup folder
set -o allexport && source .env && set +o allexport
SOURCE="${BASH_SOURCE[0]}"
while [[ -h "$SOURCE" ]]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
CURRENT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

BACKUP_FILENAME=$1

if [ -z "$BACKUP_FILENAME" ]; then
  BACKUP_FILENAME="$(date +"%Y-%m-%d_%H-%M-%S").sql"
fi

cd ${CURRENT_DIR}

mkdir -p ${CURRENT_DIR}/backups

docker exec -it base-database-1 /usr/bin/mysqldump --defaults-file=/etc/mysql/my.cnf --skip-comments --routines --triggers -uroot -p${MARIADB_ROOT_PASSWORD} dashboard > ${CURRENT_DIR}/backups/${BACKUP_FILENAME}