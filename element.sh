#!/bin/bash

# setup initial PSQL sql server access

PSQL="psql -X --username=freecodecamp --dbname=periodic_table  --tuples-only -c"

SQL_QUERY="SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM elements INNER JOIN properties using(atomic_number) INNER JOIN types USING(type_id)"


