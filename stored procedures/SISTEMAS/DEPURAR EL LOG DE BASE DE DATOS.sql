USE SINGA;  
GO  
-- Truncate the log by changing the database recovery model to SIMPLE.  
ALTER DATABASE SINGA  
SET RECOVERY SIMPLE;  
GO  
-- Shrink the truncated log file to 1 MB.  
DBCC SHRINKFILE (BATIA_Log, 1);  
GO  
-- Reset the database recovery model.  
ALTER DATABASE SINGA  
SET RECOVERY FULL;  
GO 