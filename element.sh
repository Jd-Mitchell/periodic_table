#!/bin/bash

#   Periodic Table Lookup
#   How to use:
#   In the bash cli, type './element.sh' and press enter.
#   If there is no argument, the script will show:
#       'Please provide an element as an argument.'
#   If you add the atomic number of the element, or the symbol, or the 
#   name, it will display the information for the element.
#   For example, the following arguments are accepted:
#
#       ./element.sh 1
#       ./element.sh H
#       ./element.sh Hydrogen
#
#   It's case insensitive and can also accept the following:
#
#       ./element.sh hE
#       ./element.sh hELiUm
#
#   If the element is not in the database, it will display the following:
#
#       'I could not find that element in the database.'
#

# Setup initial PSQL sql server access

PSQL="psql -X --username=freecodecamp --dbname=periodic_table  --tuples-only -c"

SQL_QUERY="SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM elements INNER JOIN properties using(atomic_number) INNER JOIN types USING(type_id)"

# If null argument

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else

# Arguments for lookup

  if [[ $1 =~ ^[0-9]+$ ]]; then
    GET_ELEMENT=$($PSQL "$SQL_QUERY WHERE atomic_number = $1")
  elif [[ ${#1} -lt 3 && $1 =~ [a-zA-Z] ]]; then
    GET_ELEMENT=$($PSQL "$SQL_QUERY WHERE symbol = INITCAP(LOWER('$1'))")
  elif [[ ${#1} -gt 2 && $1 =~ [a-zA-Z] ]]; then
    GET_ELEMENT=$($PSQL "$SQL_QUERY WHERE name = INITCAP(LOWER('$1'))")
  fi
 
# Display element details

 if [[ -z $GET_ELEMENT ]]; then
    echo "I could not find that element in the database."
  else
    echo "$GET_ELEMENT" | while read ATOMIC_NO BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NO is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi

fi
