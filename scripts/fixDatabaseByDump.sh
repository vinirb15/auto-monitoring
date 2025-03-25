#!/bin/bash

HOST="127.0.0.1"
USUARIO="traccar"
SENHA="traccar"
DATABASE="traccar"
BACKUP_FILE="backup_2025-03-04_00-00-00.sql"

INICIO=$(date +%s)

echo "Iniciando a execução do script..."

mysql -h "$HOST" -u "$USUARIO" -p"$SENHA" "$DATABASE" < "$BACKUP_FILE"

FIM=$(date +%s)
TEMPO_TOTAL=$((FIM - INICIO))
HORAS=$((TEMPO_TOTAL / 3600))
MINUTOS=$(((TEMPO_TOTAL % 3600) / 60))
SEGUNDOS=$((TEMPO_TOTAL % 60))

printf "Tempo de execução: %02d:%02d:%02d\n" $HORAS $MINUTOS $SEGUNDOS
echo "A execução do dump $BACKUP_FILE foi finalizada."

