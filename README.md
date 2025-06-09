# Deploying our docker containers

This repository serves as a base to hold docker configuration files that can serve as examples for your own docker deployments of Panintelligence.

If you're on **Azure**: please see [our azure-containers repository](https://github.com/Panintelligence/azure-containers).

# Requirements
Any system with `docker` installed or another container platform like Kubernetes.

# Getting access

Please email support@panintelligence.com with the following information:

> Company: Name of your company
>
> Username: Your [github](https://www.github.com/) username

# Deployment Methods


> **Note**
> None of the links to images will work unless you've been granted access.

## Containers
For this method, you need the following:
* The container images:
  * [panintelligence/renderer](https://github.com/orgs/pi-cr/packages/container/package/renderer)
  * [panintelligence/excel-reader](https://github.com/orgs/pi-cr/packages/container/package/excel-reader)
  * [panintelligence/scheduler](https://github.com/orgs/pi-cr/packages/container/package/scheduler) (if your licence includes piReports)
  * [panintelligence/pirana](https://github.com/orgs/pi-cr/packages/container/package/pirana) (if your licence includes piAnalytics)
  * [panintelligence/server](https://github.com/orgs/pi-cr/packages/container/package/server)
* A licence from your account manager
* Access to a filesystem of some sort to persist your custom themes and the shared keys between `server` and `scheduler`

### Using docker-compose
Clone this repository and edit [.env](docker-compose/example/.env) according to your needs.

You may also wish to edit the [docker-compose.yml](docker-compose/example/docker-compose.yml)
To modify the load balancer config, please edit [haproxy.cfg](docker-compose/example/haproxy/haproxy.cfg)

Then stand up the service like so:
```bash
cd <code source directory>/docker-compose/example
docker-compose up -d
```

## Volumes

for persistence or modification of certain files or features, it's well worth mounting the following volumes for your containers:

### Themes

If this directory is "empty" on first load of pi, default themes will populate this directory.

please mount this directory: `/var/panintelligence/Dashboard/tomcat/webapps/panMISDashboardResources/themes`

### Images

`/var/panintelligence/Dashboard/tomcat/webapps/panMISDashboardResources/images`

### Custom_JDBC
Custom JDBC drivers permit you to use a freeflow jdbc config within the dashboard.  Any JDBC jar file dropped into this folder will appear on the application class path and be available for use in Pi

`/var/panintelligence/Dashboard/tomcat/custom_jdbc_drivers`

### SVG

This directory containers the custom image SVG maps.

`/var/panintelligence/Dashboard/tomcat/webapps/panMISDashboardResources/svg`


### Keys

These keys are shared with the scheduler.  Its important that the same path is mounted on the scheduler container.  This will allow the scheduler and dashboard application to talk with one another over an encrypted channel.

`/var/panintelligence/Dashboard/keys`

## Further deployment configuration
For additional configuration options, see our [configuration Environment Variables documentation](https://panintelligence.atlassian.net/wiki/spaces/PD/pages/34374123/Environment+Variables).


# Upgrading
Provided your volumes are set up as we've recommended under the [Deployment Methods](#deployment-methods), 
upgrading is as simple as replacing the old container with a new one.

Instead of `:latest` you might want to use the specific version (e.g. `2023_03_30`).

modify the [.env](docker-compose/example/.env) tags with your new version

especially if you're using `latest` tags, you will want to execute a pull
```bash
cd <code source directory>/docker-compose/example
docker-compose pull
docker-compose up -d
```


# Gotchas
* **Kubernetes**'s own generated environment variables may clash with the some configuration environment variables, if you name your containers similarly.
* **Connecting to Oracle Databases**: you might need to pass in a TZ environment variable, otherwise the connection might fail with `ORA-00604: error occurred at recursive SQL level 1 ORA-01882: timezone region not found`. Example:`--env TZ=UTC`
* **Azure**'s container instances assume the registry is elsewhere, and as such you need to prepend `docker.io` to the image name, i.e. `docker.io/panintelligence/dashboard`
* **The Database** must be case insensitive, i.e. the `my.cnf` file must have `lower_case_table_names = 1` or you have supplied the switch in the command on startup to the db.  an example on [docker-compose.yml](docker-compose/example/docker-compose.yml)
  * You'll notice this if in the logs the dashboard complains about some tables being missing while the tables are in the database

# mariadb-sql-injector container
We have created a mariadb sql injector container to run sql commands inside the database. This is useful if you're running on serverless environments and have restricted access to the backend.
### Using docker-compose
Environment variables:
  - PI_DB_SCHEMA_NAME=<db schema name>
  - PI_DB_PASSWORD=<db password>
  - PI_DB_USERNAME=<db username>
  - PI_DB_HOST=<db host>
  - SQL_INJECT_BOOL="true"
  - SQL_FILE_NAME=<db sql file>
### Volumes:
 - <sql source directory>:/var/sql


# Getting Help
Contact support@panintelligence.com with any query or issue.
