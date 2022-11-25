# Concept Exporter

## About
Utility to check for and export concepts for IM2

## Overview
The utility performs the following tasks: -
1. Cleanup (rollback) any local pending changes (in case of error/failure on previous run)
2. Pull latest from ImportData GIT repository
3. For implemented exporters (currently "NewConcept" and "EMISMap")
4. Get rowcount from file
5. Get rowncount from database 
6. *IF* there are new rows
   1. Export latest data from table
7. *IF* there are changes
   1. Commit & push to GIT

## Installation
1. Install the ConceptExport.jar into /opt/ConceptExport/bin 
2. Copy the ConceptExport.sh wrapper script (in `resources`) into /opt/ConceptExport
3. Clone the ImportData repository into /opt/ConceptExport/ImportData
```shell
cd /opt/ConceptExport
git clone https://<USER>:<TOKEN>@github.com/endeavourhealth-discovery/ImportData
```
4. Set the GIT user details
```shell
cd /opt/ConceptExport/ImportData
git config user.name "ConceptExport"
git config user.email "ConceptExport@voror.co.uk" 
```
5. Set ConceptExport to run regularly via CRON
```shell
0 0 * * 0   root    /opt/ConceptExport/ConceptExport.sh >> /opt/ConceptExport/log.txt 2>&1
```
6. Set the relevant connection details in the config database

app-id         | config-id          | config-data
-------------- |--------------------| -----------
concept-export | im-database        | {<br>"url": "jdbc:mysql://localhost:3306/im",<br>"username": "root",<br>"password": "Pa55w0rd"<br>}
concept-export | reference-database | {<br>"url": "jdbc:mysql://localhost:3306/reference",<br>"username": "root",<br>"password": "Pa55w0rd"<br>}

