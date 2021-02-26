# Deploying our docker containers

This repository serves as a base to hold docker configuration files that can serve as examples for your own docker deployments of Panintelligence.

If you're on **Azure**: please see [our azure-containers repository](https://github.com/Panintelligence/azure-containers).

----
**Table of Contents:**
- [Deploying our docker containers](#deploying-our-docker-containers)
- [Getting access](#getting-access)
- [Deployment Methods](#deployment-methods)
  - [Single Container](#single-container)
    - [Using docker CLI](#using-docker-cli)
    - [Using docker-compose](#using-docker-compose)
  - [Single Container + External Database](#single-container--external-database)
    - [Using docker CLI](#using-docker-cli-1)
    - [Using docker-compose](#using-docker-compose-1)
  - [Multiple Containers](#multiple-containers)
    - [Using docker-compose](#using-docker-compose-2)
  - [Further deployment configuration](#further-deployment-configuration)
- [Gotchas](#gotchas)
- [Getting Help](#getting-help)

----

# Getting access

Please email support@panintelligence.com with the following information:

> Company: Name of your company
>
> Username: Your [docker hub](https://hub.docker.com/) username

# Deployment Methods

You have 3 options for deploying our containers, single-container, single-container + external database, multi-containers.

**Note:** none of the links to images will work unless you've been granted access.

## Single Container
This method is usually useful for proof of concepts.

For this method, you need the following:
* The [panintelligence/dashboard](https://hub.docker.com/r/panintelligence/dashboard) image
* A licence from your account manager
* Access to a filesystem of some sort to persist the application data

### Using docker CLI
```bash
mkdir -p /volumes/panintelligence/data   # to persist the application database
mkdir -p /volumes/panintelligence/themes # to persist the application themes
# you'll need a licence.xml file inside /volumes/panintelligence/
docker run \
    -p 0.0.0.0:8224:8224 \
    -dt \
    -v /volumes/panintelligence/data:/var/panintelligence/Dashboard/db/data \
    -v /volumes/panintelligence/themes:/var/panintelligence/Dashboard/tomcat/webapps/panMISDashboardResources/themes \
    -v /volumes/panintelligence/licence.xml:/var/panintelligence/Dashboard/tomcat/webapps/panLicenceManager/WEB-INF/classes/licence.xml \
    --name pi_dashboard \
    panintelligence/dashboard:latest
```
The commands above apply the licence via a volume, alternatively, the licence can be passed via environment variables: `PI_LICENCE=<licence>...</licence>` or `PI_LICENCE_URL=https://link/to/licence.xml`.

### Using docker-compose
Clone this repository and edit [single.yml](docker-compose/single.yml) according to your needs (particularly the volumes section).

Then stand up the service like so:
```bash
cd docker-deployments
docker-compose -f docker-compose/single.yml up -d 
```


## Single Container + External Database
For this method, you need the following:
* The [panintelligence/dashboard-marialess](https://hub.docker.com/r/panintelligence/dashboard-marialess) image
* A licence from your account manager
* Access to a filesystem of some sort to persist your custom themes
* A MariaDB or MySQL database
  * We require the database to be case insensitive, i.e. the `my.cnf` file must have `lower_case_table_names = 1`

### Using docker CLI
```bash
mkdir -p /volumes/panintelligence/themes # to persist the application themes
# you'll need a licence.xml file inside /volumes/panintelligence/
docker run \
    -p 0.0.0.0:8224:8224 \
    -dt \
    -e PI_DB_HOST="your.mariadb.com" \
    -e PI_DB_PORT=3306 \
    -e PI_DB_USERNAME="root" \
    -e PI_DB_PASSWORD="SuperSecurePasswordHere" \
    -v /volumes/panintelligence/themes:/var/panintelligence/Dashboard/tomcat/webapps/panMISDashboardResources/themes \
    -v /volumes/panintelligence/licence.xml:/var/panintelligence/Dashboard/tomcat/webapps/panLicenceManager/WEB-INF/classes/licence.xml \
    --name pi_dashboard \
    panintelligence/dashboard-marialess:latest
```
Replace the values for `PI_DB_HOST`,  `PI_DB_PORT`, `PI_DB_USERNAME` and `PI_DB_PASSWORD` accordingly.

The commands above apply the licence via a volume, alternatively, the licence can be passed via environment variables: `PI_LICENCE=<licence>...</licence>` or `PI_LICENCE_URL=https://link/to/licence.xml`.


### Using docker-compose
Clone this repository and edit [single_marialess.yml](docker-compose/single_marialess.yml) according to your needs (particularly the volumes section and the database connection environment variables).

Then stand up the service like so:
```bash
cd docker-deployments
docker-compose -f docker-compose/single_marialess.yml up -d 
```

## Multiple Containers
For this method, you need the following:
* The container images:
  * [panintelligence/renderer](https://hub.docker.com/r/panintelligence/renderer)
  * [panintelligence/excel](https://hub.docker.com/r/panintelligence/excel)
  * [panintelligence/scheduler](https://hub.docker.com/r/panintelligence/scheduler) (if your licence includes piReports)
  * [panintelligence/pirana](https://hub.docker.com/r/panintelligence/pirana) (if your licence includes piAnalytics)
  * [panintelligence/server](https://hub.docker.com/r/panintelligence/server)
* A licence from your account manager
* Access to a filesystem of some sort to persist your custom themes and the shared keys between `server` and `scheduler`
* A MariaDB or MySQL database
  * We require the database to be case insensitive, i.e. the `my.cnf` file must have `lower_case_table_names = 1`

### Using docker-compose
Clone this repository and edit [multiple.yml](docker-compose/multiple.yml) according to your needs (particularly the volumes section, the licence environment variable on `server` and the database connection environment variables for both `server` and `scheduler`).

Then stand up the service like so:
```bash
cd docker-deployments
docker-compose -f docker-compose/multiple.yml up -d 
```

## Further deployment configuration
For additional configuration options, see our [configuration Environment Variables documentation](https://panintelligence.atlassian.net/wiki/spaces/PD/pages/34374123/Environment+Variables).

# Gotchas
* **Kubernetes**'s own generated environment variables may clash with the some configuration environment variables, if you name your containers similarly.
* **Connecting to Oracle Databases**: you might need to pass in a TZ environment variable, otherwise the connection might fail with `ORA-00604: error occurred at recursive SQL level 1 ORA-01882: timezone region not found`. Example:`--env TZ=UTC`
* **Azure**'s container instances assume the registry is elsewhere, and as such you need to prepend `docker.io` to the image name, i.e. `docker.io/panintelligence/dashboard`
* **The Database** must be case insensitive, i.e. the `my.cnf` file must have `lower_case_table_names = 1`
  * You'll notice this if in the logs the dashboard complains about some tables being missing while the tables are in the database

# Getting Help
Contact support@panintelligence.com with any query or issue.