--Script to initialize database

--Connecting to master (db)
USE master

GO


--Creating Database
CREATE DATABASE DataWarehouse

GO


--Creating Schemas
CREATE SCHEMA bronze
GO
CREATE SCHEMA silver
GO
CREATE SCHEMA gold
