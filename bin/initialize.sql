------------------------------------------------------------------------------
-- Channels
------------------------------------------------------------------------------
-- Channel determines pull interval, push interval and various communication config 
-- Channel name is set to tags for transfer of tags data from offshore to onshore
delete from sym_channel where channel_id in ('tags');
insert into sym_channel (channel_id, processing_order, max_batch_size, enabled, description)
values('tags', 1, 100000, 1, 'Channel for tags data transfer');

------------------------------------------------------------------------------
-- Node Groups
------------------------------------------------------------------------------
-- Group ids set must correspond to the 'group.id' set in the properties file in the engines folder
delete from sym_node_group;
insert into sym_node_group (node_group_id) values ('offshore');
insert into sym_node_group (node_group_id) values ('onshore');

------------------------------------------------------------------------------
-- Node Group Links
------------------------------------------------------------------------------
-- Node Group links determine how different node groups are linked together

-- Master sends changes to Slave when Slave pulls from Master
insert into sym_node_group_link (source_node_group_id, target_node_group_id, data_event_action) values ('offshore', 'onshore', 'W');
-- Slave sends changes to Master when Slave pushes to Master
-- insert into sym_node_group_link (source_node_group_id, target_node_group_id, data_event_action) values ('onshore', 'offshore', 'P');

------------------------------------------------------------------------------
-- Triggers
------------------------------------------------------------------------------
-- Trigger table tells the program which tables to track to sync across nodes

-- Triggers for tables on "tags" channel, where "tagsrawdata" is the table to be synced
insert into sym_trigger (trigger_id,source_table_name,channel_id,last_update_time,create_time)
values('offshore2onshoretag','tagsrawdata','tags',now(),now());

------------------------------------------------------------------------------
-- Routers
------------------------------------------------------------------------------
-- Router determines how groups should be routed to each other, whereby router type can be changed to include expressions to define logic that determines if a change should be routed across to a specific group

-- Default router sends all data from corp to store 
insert into sym_router (router_id,source_node_group_id,target_node_group_id,router_type,create_time,last_update_time)
values('offshore2onshore', 'offshore', 'onshore', 'default', now(), now());

------------------------------------------------------------------------------
-- Trigger Routers
------------------------------------------------------------------------------
-- Relates routers to the trigger tables (link logic to select changes to be synced in a table to the targetted table to be synced)

-- Send all items to all stores
insert into sym_trigger_router (trigger_id,router_id,enabled,initial_load_order,last_update_time,create_time)
values('offshore2onshoretag','offshore2onshore',1, 1, now(), now());


