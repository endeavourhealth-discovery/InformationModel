# Concept Exporter

## About
Utility to check for and export concepts from the IM(v1) concept table.

## Overview
The utility performs the following tasks: -
1. Cleanup (rollback) any local pending changes (in case of error/failure on previous run)
2. Pull latest from ImportData GIT repository
3. Extract last DBID from IMv1/concepts.txt
4. Get latest DBID from concept table
5. *IF* there are new concepts
   1. Export latest data from table
   2. Zip concept file
   3. Commit & push to GIT

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
