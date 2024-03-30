#!/bin/bash

# PSQL variable for querying the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if no arguments provided
if [ $# -eq 0 ]; then
    echo "Please provide an element as an argument."
    exit 0
fi

# Get element information based on the provided argument
element_info=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number WHERE elements.atomic_number = $1 OR elements.symbol = '$1' OR elements.name = '$1';")

# Check if element information is found
if [ -z "$element_info" ]; then
    echo "I could not find that element in the database."
    exit 0
fi

# Print element information
echo "$element_info" | while read -r line; do
    atomic_number=$(echo "$line" | cut -d '|' -f 1)
    name=$(echo "$line" | cut -d '|' -f 2)
    symbol=$(echo "$line" | cut -d '|' -f 3)
    atomic_mass=$(echo "$line" | cut -d '|' -f 4)
    melting_point=$(echo "$line" | cut -d '|' -f 5)
    boiling_point=$(echo "$line" | cut -d '|' -f 6)
    type=$(echo "$line" | cut -d '|' -f 7)
    
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
done

exit 0
