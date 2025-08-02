#!/bin/bash

# Create PSQL variable
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

# Rename weight column to atomic_mass
$($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass")

# Rename melting_point column to melting_point_celsius
$($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius")

# Rename boiling_point column to boiling_point_celsius
$($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius")

# Make melting_point_celsius column not null
$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL")

# Make boiling_point_celsius column not null
$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL")

# Make symbol column unique
$($PSQL "ALTER TABLE elements ADD UNIQUE(symbol)")

# Make name column unique
$($PSQL "ALTER TABLE elements ADD UNIQUE(name)")

# Make symbol column not null
$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL")

# Make name column not null
$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL")

# Set atomic_number column as foreign key
$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number)")

# Create types table
$($PSQL "CREATE TABLE types()")

# Add type_id column
$($PSQL "ALTER TABLE types ADD COLUMN type_id SERIAL PRIMARY KEY")

# Add type column
$($PSQL "ALTER TABLE types ADD COLUMN type VARCHAR(25) NOT NULL")

# Add row on types table -> nonmetal & metal & metalloid
$($PSQL "INSERT INTO types(type) VALUES('nonmetal'),('metal'),('metalloid')")

# Add type_id column to properties table
$($PSQL "ALTER TABLE properties ADD COLUMN type_id INT REFERENCES types(type_id)")

# Add values to type_id
$($PSQL "UPDATE properties SET type_id=1 WHERE type='nonmetal'")
$($PSQL "UPDATE properties SET type_id=2 WHERE type='metal'")
$($PSQL "UPDATE properties SET type_id=3 WHERE type='metalloid'")

# Make type_id not null
$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL")

# Capitalize the first letter of all symbol values
$($PSQL "UPDATE elements SET symbol = INITCAP(symbol) WHERE symbol IS NOT NULL;")

# Delete non existing element
$($PSQL "DELETE FROM properties WHERE atomic_number=1000")
$($PSQL "DELETE FROM elements WHERE atomic_number=1000")

# Remove trailng zeros
$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass SET DATA TYPE DECIMAL")
$($PSQL "UPDATE properties SET atomic_mass=(TRIM(TRAILING '0' FROM atomic_mass::TEXT))::DECIMAL WHERE atomic_mass IS NOT NULL;")

# Add element with atomic number 9
$($PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(9,'F','Fluorine')")
$($PSQL "INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius,type_id) VALUES(9,18.998,-220,-188.1,1)")

# Add element with atomic number 10
$($PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(10,'Ne','Neon')")
$($PSQL "INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES(10,20.18, -248.6, -246.1, 1)")

# Drop type column from properties table
$($PSQL "ALTER TABLE properties DROP COLUMN type")
