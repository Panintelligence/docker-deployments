---
title: Standard Example
description: Our most basic container deployment style
---

This files in the [standard](https://github.com/Panintelligence/docker-deployments/tree/docker_deployments_improvements/standard) directory represent a basic pi environment.

### Environment variables
Copy `template.env` to `.env` and update the values before you start.
### Compose Profiles
You can use the `COMPOSE_PROFILES` entry in your .env to choose components to run, for example `full` (for everything) or `dashboard,database` if you only wanted the absolute minimum.

### Up
Start with `docker compose -f compose.yml up -d`

### Down
Stop with `docker compose -f compose.yml down`

### Overrides
Override files allow you to customise values for specific use cases, for example
`docker compose -f compose.yml -f compose.ports_open.yml up -d` will open all the application ports which is useful for debugging but not recommended in production

### Scripts
Scripts exist to do the following:
- db_backup.sh: Takes a backup of your repository data

### After startup
After startup you will need to go into the Dashboard admin area and configure the

### Backup
You can use the db_backup.sh script to take a backup of the repository db data, the backup will appear timestamped in the backups folder

### Restore
By placing an sql file in the database_import the data will be imported if there is no data in your db_data volume. If you want to remove existing data use `docker compose down -v`