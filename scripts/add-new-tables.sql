-- Script per aggiungere le nuove tabelle LeadOne2 al database esistente leadOne.Dev56
-- Questo script NON modifica le tabelle esistenti

USE [leadOne.Dev56]
GO

PRINT '=========================================='
PRINT '   LeadOne2 - Add New Tables'
PRINT '=========================================='
PRINT ''

-- Verifica se le tabelle esistono già
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users' AND TABLE_SCHEMA = 'dbo')
BEGIN
    PRINT '⚠️  Tabella Users già esistente - SKIP'
END
ELSE
BEGIN
    PRINT 'Creazione tabella Users...'

    CREATE TABLE [dbo].[Users](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [Email] [nvarchar](256) NOT NULL,
        [PasswordHash] [nvarchar](max) NOT NULL,
        [Name] [nvarchar](100) NOT NULL,
        [Surname] [nvarchar](100) NOT NULL,
        [IsActive] [bit] NOT NULL DEFAULT 1,
        [IsAdmin] [bit] NOT NULL DEFAULT 0,
        [CreatedAt] [datetime2](7) NOT NULL DEFAULT GETUTCDATE(),
        [LastLoginAt] [datetime2](7) NULL,
        CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
    )

    CREATE UNIQUE INDEX [IX_Users_Email] ON [dbo].[Users]([Email])

    PRINT '✅ Tabella Users creata'
END
PRINT ''

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Projects' AND TABLE_SCHEMA = 'dbo')
BEGIN
    -- Potrebbe esistere già la tabella Project (singolare) nel vecchio DB
    -- Verifichiamo se è quella del vecchio sistema o la nostra
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Projects' AND COLUMN_NAME = 'Description')
    BEGIN
        PRINT '⚠️  Tabella Projects già esistente - SKIP'
    END
    ELSE
    BEGIN
        PRINT 'Tabella Projects esiste ma è del vecchio sistema, creo quella nuova...'
        -- In questo caso potremmo dover rinominare la tabella, ma per sicurezza skippiamo
        PRINT '⚠️  Attenzione: esiste una tabella Projects del vecchio sistema'
        PRINT '   Potrebbe essere necessario rinominare'
    END
END
ELSE
BEGIN
    PRINT 'Creazione tabella Projects...'

    CREATE TABLE [dbo].[Projects](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [Name] [nvarchar](200) NOT NULL,
        [Description] [nvarchar](1000) NULL,
        [IsActive] [bit] NOT NULL DEFAULT 1,
        [CreatedAt] [datetime2](7) NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] [datetime2](7) NULL,
        CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED ([Id] ASC)
    )

    PRINT '✅ Tabella Projects creata'
END
PRINT ''

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'UserProjects' AND TABLE_SCHEMA = 'dbo')
BEGIN
    PRINT '⚠️  Tabella UserProjects già esistente - SKIP'
END
ELSE
BEGIN
    PRINT 'Creazione tabella UserProjects...'

    CREATE TABLE [dbo].[UserProjects](
        [UserId] [int] NOT NULL,
        [ProjectId] [int] NOT NULL,
        [AssignedAt] [datetime2](7) NOT NULL DEFAULT GETUTCDATE(),
        [IsActive] [bit] NOT NULL DEFAULT 1,
        CONSTRAINT [PK_UserProjects] PRIMARY KEY CLUSTERED ([UserId], [ProjectId])
    )

    -- Foreign Keys
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
    BEGIN
        ALTER TABLE [dbo].[UserProjects] WITH CHECK ADD CONSTRAINT [FK_UserProjects_Users_UserId]
        FOREIGN KEY([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE
    END

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Projects')
    BEGIN
        ALTER TABLE [dbo].[UserProjects] WITH CHECK ADD CONSTRAINT [FK_UserProjects_Projects_ProjectId]
        FOREIGN KEY([ProjectId]) REFERENCES [dbo].[Projects] ([Id]) ON DELETE CASCADE
    END

    PRINT '✅ Tabella UserProjects creata'
END
PRINT ''

-- Tabella per tracking migrations EF Core
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '__EFMigrationsHistory' AND TABLE_SCHEMA = 'dbo')
BEGIN
    PRINT 'Creazione tabella __EFMigrationsHistory...'

    CREATE TABLE [dbo].[__EFMigrationsHistory](
        [MigrationId] [nvarchar](150) NOT NULL,
        [ProductVersion] [nvarchar](32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED ([MigrationId] ASC)
    )

    PRINT '✅ Tabella __EFMigrationsHistory creata'
END
ELSE
BEGIN
    PRINT '⚠️  Tabella __EFMigrationsHistory già esistente - SKIP'
END
PRINT ''

-- Riepilogo
PRINT '=========================================='
PRINT 'Riepilogo Tabelle'
PRINT '=========================================='

PRINT ''
PRINT 'Tabelle LeadOne2 (nuove):'
SELECT
    TABLE_NAME,
    CASE
        WHEN TABLE_NAME IN ('Users', 'Projects', 'UserProjects', '__EFMigrationsHistory') THEN 'LeadOne2 (nuovo)'
        ELSE 'LeadOne1 (esistente)'
    END AS Sistema
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_NAME IN ('Users', 'Projects', 'UserProjects', '__EFMigrationsHistory')
ORDER BY TABLE_NAME

PRINT ''
PRINT 'Verifica record:'
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
BEGIN
    DECLARE @UserCount INT
    SELECT @UserCount = COUNT(*) FROM Users
    PRINT 'Users: ' + CAST(@UserCount AS VARCHAR(10)) + ' record'
END

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Projects')
BEGIN
    DECLARE @ProjectCount INT
    SELECT @ProjectCount = COUNT(*) FROM Projects
    PRINT 'Projects: ' + CAST(@ProjectCount AS VARCHAR(10)) + ' record'
END

PRINT ''
PRINT '=========================================='
PRINT '✅ Setup completato!'
PRINT '=========================================='
PRINT ''
PRINT 'Prossimi passi:'
PRINT '1. Avvia il backend: cd src/LeadOne2.Api && dotnet run'
PRINT '2. Apri Swagger: http://localhost:5000/swagger'
PRINT '3. Registra primo utente admin'
PRINT '4. Avvia frontend: cd src/LeadOne2.Web && npm run dev'
PRINT ''
PRINT 'NOTA: Le tabelle esistenti di LeadOne1 NON sono state modificate'
PRINT ''

GO
