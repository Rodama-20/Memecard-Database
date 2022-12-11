# Readme MemecardDb

The present project hold the database for settign up Memecard.

## How to use

Connect to the database with its credentials and then run the following commands:

Full installation with data:

```sql
\i global.sql
```

Only the structure:

```sql
\i schema/schema.sql
\i schema/procedure.sql
```

## File Structure

## Schema folder

The schema folder contains the schema for the database. The schema file defines the structure of the database written for PostgreSQL.
The procedure file creates procedure to manage some function which are handled by the database.

## Data folder
The data folder contains the SQL instruction to add a basic example to the database.