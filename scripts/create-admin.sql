-- Script per creare un utente Admin direttamente nel database
-- Utilizzare solo se necessario, altrimenti usa Swagger per registrare l'utente

USE LeadOne2;
GO

-- Verifica se l'utente esiste già
IF EXISTS (SELECT 1 FROM Users WHERE Email = 'admin@leadone.it')
BEGIN
    PRINT 'Utente admin@leadone.it già esistente'

    -- Aggiorna a ruolo admin se non lo è già
    UPDATE Users
    SET IsAdmin = 1, IsActive = 1
    WHERE Email = 'admin@leadone.it';

    PRINT 'Utente aggiornato a ruolo Admin'
END
ELSE
BEGIN
    -- Password: Admin123!
    -- Questo è l'hash BCrypt per "Admin123!"
    -- ⚠️ CAMBIA LA PASSWORD DOPO IL PRIMO LOGIN!

    INSERT INTO Users (Email, PasswordHash, Name, Surname, IsActive, IsAdmin, CreatedAt)
    VALUES (
        'admin@leadone.it',
        '$2a$11$YourBCryptHashHere', -- ⚠️ Sostituire con hash BCrypt valido
        'Admin',
        'LeadOne',
        1, -- IsActive
        1, -- IsAdmin
        GETUTCDATE()
    );

    PRINT 'Utente Admin creato con successo!'
    PRINT 'Email: admin@leadone.it'
    PRINT 'Password: Admin123!'
    PRINT '⚠️  CAMBIA LA PASSWORD DOPO IL PRIMO LOGIN!'
END
GO

-- Verifica utente creato
SELECT
    Id,
    Email,
    Name,
    Surname,
    IsAdmin,
    IsActive,
    CreatedAt
FROM Users
WHERE Email = 'admin@leadone.it';
GO
