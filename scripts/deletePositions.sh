#!/bin/bash

DB_HOST="127.0.0.1"
DB_USER="traccar"
DB_PASS="traccar"
DB_NAME="traccar"
QUEUE_SIZE=100000  
MYSQL_CMD="mysql --defaults-extra-file=~/.my.cnf -h $DB_HOST -D $DB_NAME -N -se"

echo -e "[client]\nuser=$DB_USER\npassword=$DB_PASS" > ~/.my.cnf
chmod 600 ~/.my.cnf  

COUNT=$($MYSQL_CMD "SELECT COUNT(*) FROM tc_positions WHERE servertime < NOW() - INTERVAL 6 MONTH;")
echo "Registros antigos restantes: $COUNT"

START_TIME=$(date +%s%N) 
$MYSQL_CMD "SELECT * FROM tc_positions WHERE servertime < NOW() - INTERVAL 6 MONTH LIMIT $QUEUE_SIZE;" > /dev/null
END_TIME=$(date +%s%N) 

ELAPSED_TIME=$(( (END_TIME - START_TIME) / 1000000 )) 
ELAPSED_SEC=$(echo "scale=3; $ELAPSED_TIME / 1000 + 1" | bc) 
echo "Tempo de execução da consulta COUNT: ${ELAPSED_SEC}s"

if [ "$COUNT" -gt 0 ]; then
  TOTAL_BATCHES=$(( (COUNT + QUEUE_SIZE - 1) / QUEUE_SIZE )) 
  ESTIMATED_TIME=$(echo "scale=2; $TOTAL_BATCHES * $ELAPSED_SEC" | bc)
  echo "Tempo estimado para deletar todos os registros: ~${ESTIMATED_TIME}s"
fi

while [ "$COUNT" -gt 0 ]; do
  $MYSQL_CMD "DELETE FROM tc_positions WHERE servertime < NOW() - INTERVAL 6 MONTH LIMIT $QUEUE_SIZE;"

  if [ "$COUNT" -ge "$QUEUE_SIZE" ]; then
    COUNT=$((COUNT - QUEUE_SIZE))
  else
    COUNT=0
  fi

  echo "Deletados $QUEUE_SIZE registros. Registros restantes estimados: $COUNT"
  sleep 1
done

rm -f ~/.my.cnf

echo "Processo concluído!"
