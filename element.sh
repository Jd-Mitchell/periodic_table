#!/bin/bash

# setup initial PSQL sql server access

PSQL="psql -X --username=freecodecamp --dbname=periodic_table  --tuples-only -c"

SQL_QUERY="SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM elements INNER JOIN properties using(atomic_number) INNER JOIN types USING(type_id)"

# if null argument

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]; then
    GET_ELEMENT=$($PSQL "$SQL_QUERY WHERE atomic_number = $1")
  elif [[ ${#1} -lt 3 && $1 =~ [a-zA-Z] ]]; then
    GET_ELEMENT=$($PSQL "$SQL_QUERY WHERE symbol = INITCAP(LOWER('$1'))")
  elif [[ ${#1} -gt 2 && $1 =~ [a-zA-Z] ]]; then
    GET_ELEMENT=$($PSQL "$SQL_QUERY WHERE name = INITCAP(LOWER('$1'))")
  fi
  echo $GET_ELEMENT
 
fi
