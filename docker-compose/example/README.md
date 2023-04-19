# Panintelligence docker-compose

## Prereqisite steps

please add the following to your hosts file 
```bash
127.0.0.1    local.pi-dash.uk
```  

This will intercept your local dns and forward all traffic bound for local.pi-dash.uk to your 
local loopback.  Should you wish to use HTTPS locally, you will wand to set this to whatever
address is specified on your certificate.

## Configuring the environment

The most commonly changed values are set in an .env file (which may be hidden on your local file
system).  If you edit this, you will have the ability to set the version of the dashboard (currently
set to latest) and to set your licence. 

You can either use a "Automated Licence Manager" Unique idenfifier for the licence, or alternatively,
if you have an XML licence, you can set that here.

## How to launch
Before first run, you must ensure you're logged in to docker by executing
```bash 
docker login
```
then you can run 

```bash
docker-compose up -d
```


## Scaling 
To simulate multi-dashboard environment, it's possible to scale up by executing the following
command.

```bash
docker-compose up -d --scale dashboard=3
```

## Ha proxy

a default configuration is set for haproxy.  This makes use of service discovery to route traffic
to the relevant containers. 

## database

to set a default repo, add your repo dump file to the ./database_repo directory. Any sql file 
will be executed on first start of the database service.  the execution order of any files found in 
this directory is numerical then alphabetical.  You may use this to your advantage to sequence 
multiple sql files.

## Connecting to the dashboard

After you've started up, you can visit http://local.pi-dash.uk:8404 to view information about your 
deployment.

Following this, to access your dashboard, you can visit http://local.pi-dash.uk/pi.
you can use 

## Tearing down
When you're done with Panintelligence on your local machine, you may execute the following command
```bash
docker-compose down -v
```

This will remove your non-persistent volumes (files that are not "owned" by the compose configuration).
As a default configuration, this is the database repo contents and the shared keys 
between the panintelligence application and the scheduler.

