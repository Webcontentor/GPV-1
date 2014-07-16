/*
  Copyright 2014 Applied Geographics, Inc.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  GPV31_SQLServer_Upgrade.sql

  Creates the GPV v4.1 configuration tables from an existing set of GPV v3.1 tables.
  Set the prefixes for both sets of table names by changing the values in the "set @prefix31" 
  and "set @prefix41" lines below.  Make sure to run GPV41_SQLServer_AddConstraints.sql 
  using the v4.1 prefix to create the necessary constraints on the v4.1 tables.

*/

declare @prefix31 nvarchar(50)
declare @prefix41 nvarchar(50)

set @prefix31 = 'GPV31'
set @prefix41 = 'GPV41'

declare @sql nvarchar(2000)

/* copy tables */

set @sql = 'SELECT * INTO ' + @prefix41 + 'Application FROM ' + @prefix31 + 'Application'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'ApplicationMapTab FROM ' + @prefix31 + 'ApplicationMapTab'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'ApplicationMarkupCategory FROM ' + @prefix31 + 'ApplicationMarkupCategory'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'ApplicationPrintTemplate FROM ' + @prefix31 + 'ApplicationPrintTemplate'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'Connection FROM ' + @prefix31 + 'Connection'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'DataTab FROM ' + @prefix31 + 'DataTab'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'ExternalMap FROM ' + @prefix31 + 'ExternalMap'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'Layer FROM ' + @prefix31 + 'Layer'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'LayerFunction FROM ' + @prefix31 + 'LayerFunction'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'LayerProximity FROM ' + @prefix31 + 'LayerProximity'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'Level FROM ' + @prefix31 + 'Level'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'MailingLabel FROM ' + @prefix31 + 'MailingLabel'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'MapTab FROM ' + @prefix31 + 'MapTab'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'MapTabLayer FROM ' + @prefix31 + 'MapTabLayer'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'Markup FROM ' + @prefix31 + 'Markup'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'MarkupCategory FROM ' + @prefix31 + 'MarkupCategory'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'MarkupGroup FROM ' + @prefix31 + 'MarkupGroup'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'MarkupSequence FROM ' + @prefix31 + 'MarkupSequence'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'PrintTemplate FROM ' + @prefix31 + 'PrintTemplate'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'PrintTemplateContent FROM ' + @prefix31 + 'PrintTemplateContent'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'Proximity FROM ' + @prefix31 + 'Proximity'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'Query FROM ' + @prefix31 + 'Query'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'SavedState FROM ' + @prefix31 + 'SavedState'
exec(@sql)

/* create GPVSearch */

set @sql = 'CREATE TABLE ' + @prefix41 + 'Search (
  SearchID nvarchar(50) NOT NULL,
  LayerID nvarchar(50) NOT NULL,
  DisplayName nvarchar(50) NOT NULL,
  ConnectionID nvarchar(50),
  SelectStatement nvarchar(2000) NOT NULL,
  SequenceNo smallint NOT NULL,
  AuthorizedRoles nvarchar(200),
  Active smallint DEFAULT 1
)'
exec(@sql)

/* create GPVSearchCriteria */

set @sql = 'CREATE TABLE ' + @prefix41 + 'SearchCriteria (
  SearchCriteriaID nvarchar(50) NOT NULL,
  SearchID nvarchar(50) NOT NULL,
  DisplayName nvarchar(50) NOT NULL,
  ColumnName nvarchar(50) NOT NULL,
  SearchCriteriaType nvarchar(50) NOT NULL,
  ConnectionID nvarchar(50),
  StoredProc nvarchar(100),
  SequenceNo smallint NOT NULL,
  Active smallint DEFAULT 1
)'
exec(@sql)

/* copy tables */

set @sql = 'SELECT * INTO ' + @prefix41 + 'UsageTracking FROM ' + @prefix31 + 'UsageTracking'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'User FROM ' + @prefix31 + 'User'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'Zone FROM ' + @prefix31 + 'Zone'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'ZoneLevel FROM ' + @prefix31 + 'ZoneLevel'
exec(@sql)

set @sql = 'SELECT * INTO ' + @prefix41 + 'ZoneLevelCombo FROM ' + @prefix31 + 'ZoneLevelCombo'
exec(@sql)
