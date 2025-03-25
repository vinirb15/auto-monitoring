#!/bin/bash

HOST="127.0.0.1"
USUARIO="traccar"
SENHA="traccar"
DATABASE="traccar"
DATA=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="backup_${DATA}.sql"

mysqldump -h "$HOST" -u "$USUARIO" -p"$SENHA" --no-tablespaces "$DATABASE" > "$BACKUP_FILE"

echo "Backup salvo como $BACKUP_FILE"

