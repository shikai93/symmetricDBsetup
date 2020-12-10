### Setup For Symmetric Database
This is a setup initialization file to setup a master and a slave node for postgresql driver. Master Node (offshore)'s changes would be implemented as is on the Slave Node (onshore). This Symmetric Database program should live on an intermediate instance between master and slave node or on the master db itself. 

## Instructions
1. Modify the two properties files in the engines folder to set the right postgresql url for both nodes along with the postgresql credentials for the database
2. Run `./bin/symadmin --engine offshoreNode create-sym-tables` where offshodeNode is the engine name of the master node defined in the engine folder, offshore.properties
3. Run the sql queries defined in bin/initialize.sql to insert the corresponding node, groups, routers, trigger_router, channel and group_links.
4. Ensure the Slave database has the same target table created in the same schema with the same properties
5. Run `./bin/sym.bat` and the 2 databases' target tables should be synced

## Samples
Samples from symmetric DB is included in the samples folder as a guide for hosting 3 nodes on the same isntance
## Logs
Logs are created in logs folder. 
the following logs are created on successful setup
>2020-12-10 11:40:24,383 INFO [offshoreNode] [RegistrationService] [qtp27084827-17] Just opened registration for external id of 001 and a node group of onshore and a node id of 001
>2020-12-10 11:40:24,389 INFO [offshoreNode] [RegistrationService] [qtp27084827-17] Completed registration of node onshore:001:001
>2020-12-10 11:40:26,092 INFO [onshoreNode] [RegistrationService] [onshoreNode-job-3] Successfully registered node [id=001]

The following logs should be created on send data (when there are new changes)
>2020-12-10 12:11:26,608 INFO [offshoreNode] [PullUriHandler] [qtp27084827-14] 1 data and 1 batches sent during pull request from onshore:001:001
>2020-12-10 12:11:26,651 INFO [onshoreNode] [PullService] [onshorenode-pull-default-1] Pull data received from offshore:000:000 on queue default. 1 rows and 1 batches were processed. (sym_node_host)


More info here [Symmetric DB Docs](https://www.symmetricds.org/doc/3.12/html/tutorials.html#_configure)<a></a>