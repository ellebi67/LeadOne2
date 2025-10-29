-- Script per verificare la corretta creazione del database

USE LeadOne2;
GO

PRINT '=========================================='
PRINT '   LeadOne2 - Database Verification'
PRINT '=========================================='
PRINT ''

-- Verifica tabelle create
PRINT '1. Tabelle create:'
SELECT
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
PRINT ''

-- Conta record per tabella
PRINT '2. Record per tabella:'
DECLARE @TableName VARCHAR(255)
DECLARE @SQL NVARCHAR(MAX)

DECLARE table_cursor CURSOR FOR
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME

OPEN table_cursor
FETCH NEXT FROM table_cursor INTO @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = N'SELECT ''' + @TableName + ''' AS TableName, COUNT(*) AS RecordCount FROM [' + @TableName + ']'
    EXEC sp_executesql @SQL

    FETCH NEXT FROM table_cursor INTO @TableName
END

CLOSE table_cursor
DEALLOCATE table_cursor
PRINT ''

-- Verifica utenti
PRINT '3. Utenti registrati:'
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
BEGIN
    SELECT
        Id,
        Email,
        Name,
        Surname,
        IsAdmin,
        IsActive,
        CreatedAt
    FROM Users;
END
ELSE
BEGIN
    PRINT 'Tabella Users non trovata!'
END
PRINT ''

-- Verifica progetti
PRINT '4. Progetti creati:'
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Projects')
BEGIN
    SELECT
        Id,
        Name,
        Description,
        IsActive,
        CreatedAt
    FROM Projects;
END
ELSE
BEGIN
    PRINT 'Tabella Projects non trovata!'
END
PRINT ''

PRINT '=========================================='
PRINT 'Verifica completata!'
PRINT '=========================================='
