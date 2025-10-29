# Quick Start - Usa Database Esistente

Guida per testare LeadOne2 con il database **leadOne.Dev56** esistente.

## 📥 1. Scarica il Codice

Se non l'hai ancora clonato:

```bash
git clone [URL_REPOSITORY]
cd LeadOne2
git checkout claude/session-011CUZxE2cL4HbvNoQbwQBGt
```

## ⚙️ 2. Configura Connection String

Apri `src/LeadOne2.Api/appsettings.json` e modifica la connection string per puntare al tuo database esistente:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=leadOne.Dev56;Integrated Security=True;TrustServerCertificate=True;"
  },
  "JwtSettings": {
    "SecretKey": "your-super-secret-key-change-this-in-production-minimum-32-characters",
    "Issuer": "LeadOne2",
    "Audience": "LeadOne2",
    "ExpirationMinutes": "1440"
  }
}
```

**Modifica in base al tuo setup**:

```json
// Se usi SQL Server con autenticazione Windows
"Server=localhost;Database=leadOne.Dev56;Integrated Security=True;TrustServerCertificate=True;"

// Se usi SQL Server con autenticazione SQL
"Server=localhost;Database=leadOne.Dev56;User Id=sa;Password=YourPassword;TrustServerCertificate=True;"

// Se usi SQL Server Express
"Server=localhost\\SQLEXPRESS;Database=leadOne.Dev56;Integrated Security=True;TrustServerCertificate=True;"
```

## 🗄️ 3. Aggiungi Nuove Tabelle al DB Esistente

LeadOne2 ha bisogno di 3 nuove tabelle che convivranno con quelle esistenti:
- **Users** (nuovo sistema di autenticazione JWT)
- **Projects** (nuova gestione progetti)
- **UserProjects** (relazione many-to-many)

### Opzione A: Via Migrations (Raccomandato)

```bash
cd src/LeadOne2.Api

# Crea migration
dotnet ef migrations add AddLeadOne2Tables --project ../LeadOne2.Infrastructure

# Applica al database (aggiungerà solo le nuove tabelle)
dotnet ef database update
```

### Opzione B: Via SQL Diretto

Se preferisci vedere cosa viene creato, usa questo script SQL:

```sql
USE [leadOne.Dev56]
GO

-- Tabella Users (nuovo sistema auth)
CREATE TABLE [dbo].[Users](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Email] [nvarchar](256) NOT NULL,
    [PasswordHash] [nvarchar](max) NOT NULL,
    [Name] [nvarchar](100) NOT NULL,
    [Surname] [nvarchar](100) NOT NULL,
    [IsActive] [bit] NOT NULL,
    [IsAdmin] [bit] NOT NULL,
    [CreatedAt] [datetime2](7) NOT NULL,
    [LastLoginAt] [datetime2](7) NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE UNIQUE INDEX [IX_Users_Email] ON [dbo].[Users]([Email])
GO

-- Tabella Projects
CREATE TABLE [dbo].[Projects](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](200) NOT NULL,
    [Description] [nvarchar](1000) NULL,
    [IsActive] [bit] NOT NULL,
    [CreatedAt] [datetime2](7) NOT NULL,
    [UpdatedAt] [datetime2](7) NULL,
    CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

-- Tabella UserProjects (many-to-many)
CREATE TABLE [dbo].[UserProjects](
    [UserId] [int] NOT NULL,
    [ProjectId] [int] NOT NULL,
    [AssignedAt] [datetime2](7) NOT NULL,
    [IsActive] [bit] NOT NULL,
    CONSTRAINT [PK_UserProjects] PRIMARY KEY CLUSTERED ([UserId], [ProjectId])
)
GO

ALTER TABLE [dbo].[UserProjects] WITH CHECK ADD CONSTRAINT [FK_UserProjects_Users_UserId]
FOREIGN KEY([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UserProjects] WITH CHECK ADD CONSTRAINT [FK_UserProjects_Projects_ProjectId]
FOREIGN KEY([ProjectId]) REFERENCES [dbo].[Projects] ([Id]) ON DELETE CASCADE
GO

-- Tabella per tracking migrations
CREATE TABLE [dbo].[__EFMigrationsHistory](
    [MigrationId] [nvarchar](150) NOT NULL,
    [ProductVersion] [nvarchar](32) NOT NULL,
    CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED ([MigrationId] ASC)
)
GO

PRINT 'Tabelle LeadOne2 create con successo!'
PRINT 'Le tabelle esistenti non sono state modificate.'
GO
```

## 🔧 4. Compila il Backend

```bash
cd src/LeadOne2.Api

# Restore pacchetti
dotnet restore

# Build
dotnet build

# Se tutto ok, dovresti vedere:
# Build succeeded.
```

## ▶️ 5. Avvia il Backend

```bash
cd src/LeadOne2.Api
dotnet run
```

**Output atteso**:
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
```

✅ Backend attivo su: **http://localhost:5000**
✅ Swagger UI su: **http://localhost:5000/swagger**

## 🎨 6. Avvia il Frontend

**Nuovo terminale/prompt**:

```bash
cd src/LeadOne2.Web

# Installa dipendenze (solo la prima volta)
npm install

# Avvia
npm run dev
```

**Output atteso**:
```
VITE v7.x.x  ready in XXX ms

➜  Local:   http://localhost:5173/
➜  Network: use --host to expose
```

✅ Frontend attivo su: **http://localhost:5173**

## 👤 7. Crea Primo Utente

### Via Swagger (più facile)

1. Apri **http://localhost:5000/swagger**
2. Espandi `POST /api/auth/register`
3. Click "Try it out"
4. Inserisci:

```json
{
  "email": "admin@leadone.it",
  "password": "Admin123!",
  "name": "Admin",
  "surname": "LeadOne"
}
```

5. Click "Execute"
6. Copia il **token** dalla response

### Imposta come Admin

Nel tuo SQL Server Management Studio:

```sql
USE [leadOne.Dev56]
GO

-- Imposta l'utente come admin
UPDATE Users
SET IsAdmin = 1
WHERE Email = 'admin@leadone.it'
GO

-- Verifica
SELECT Id, Email, Name, Surname, IsAdmin, IsActive
FROM Users
GO
```

## 🧪 8. Testa l'Applicazione

### Test Frontend

1. Apri **http://localhost:5173**
2. Dovresti vedere la pagina di login
3. Inserisci:
   - Email: `admin@leadone.it`
   - Password: `Admin123!`
4. Click "Accedi"
5. Se tutto funziona, verrai reindirizzato alla pagina progetti

### Test API (Swagger)

1. Apri **http://localhost:5000/swagger**
2. Testa `POST /api/auth/login` con le tue credenziali
3. Copia il token dalla response
4. Click sul lucchetto 🔒 "Authorize" in alto
5. Inserisci: `Bearer YOUR_TOKEN`
6. Testa altre API (progetti, utente corrente, etc.)

## ✅ Checklist Verifica

- [ ] Repository clonato/aggiornato
- [ ] Connection string configurata per leadOne.Dev56
- [ ] Nuove tabelle create (Users, Projects, UserProjects)
- [ ] Backend compila senza errori
- [ ] Backend in esecuzione su http://localhost:5000
- [ ] Swagger accessibile
- [ ] Frontend dipendenze installate (npm install)
- [ ] Frontend in esecuzione su http://localhost:5173
- [ ] Utente admin creato
- [ ] Login frontend funzionante
- [ ] Vedo la pagina progetti

## 🐛 Troubleshooting

### Errore: "Cannot connect to database"

**Verifica**:
```bash
# Testa connection string con sqlcmd
sqlcmd -S localhost -d leadOne.Dev56 -Q "SELECT DB_NAME()"
```

Se usa autenticazione SQL:
```bash
sqlcmd -S localhost -U sa -P YourPassword -d leadOne.Dev56 -Q "SELECT DB_NAME()"
```

### Errore: "Table Users already exists"

Se hai già eseguito le migrations:
```bash
cd src/LeadOne2.Api

# Verifica migrations applicate
dotnet ef migrations list

# Se necessario, rimuovi e ricrea
dotnet ef database drop --force
# NO! Non fare drop se hai dati importanti!
```

**Meglio**: Controlla nel DB se le tabelle esistono già:
```sql
USE [leadOne.Dev56]
SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME IN ('Users', 'Projects', 'UserProjects')
```

### Errore: "Port 5000 already in use"

Cambia porta in `src/LeadOne2.Api/Properties/launchSettings.json`:
```json
"applicationUrl": "http://localhost:5001"
```

E aggiorna in `src/LeadOne2.Web/src/services/api.ts`:
```typescript
const API_URL = 'http://localhost:5001/api';
```

### Errore: "CORS policy"

Verifica che:
1. Backend sia in esecuzione
2. Frontend chiami l'URL corretto (http://localhost:5000)
3. CORS sia configurato in `Program.cs` (già fatto)

### Frontend non si connette

**Verifica API URL** in `src/LeadOne2.Web/src/services/api.ts`:
```typescript
const API_URL = 'http://localhost:5000/api';  // Deve corrispondere al backend
```

## 📊 Verifica Database

Dopo aver creato le nuove tabelle, verifica che coesistano con quelle vecchie:

```sql
USE [leadOne.Dev56]
GO

-- Tutte le tabelle
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME
GO

-- Dovresti vedere sia le vecchie che le nuove:
-- Vecchie: AspNetUsers, AspNetRoles, Companies, People, Calls, etc.
-- Nuove: Users, Projects, UserProjects
```

## 🎯 Prossimi Passi

Una volta che tutto funziona:

1. ✅ Familiarizza con l'interfaccia
2. ✅ Crea qualche progetto di test
3. ✅ Testa l'assegnazione utenti ai progetti
4. ✅ Esplora il codice

Poi potremo:
- Implementare Companies (collegandole alle tabelle esistenti)
- Implementare People
- Implementare Calls
- Integrare con OpiVoice
- Migrare i dati dal vecchio sistema

## 📞 Note Importanti

⚠️ **Database Condiviso**: LeadOne2 condivide il database con LeadOne 1:
- Le **nuove tabelle** (Users, Projects, UserProjects) sono per il nuovo sistema
- Le **vecchie tabelle** (AspNetUsers, Companies, People, etc.) rimangono intatte
- In futuro migrereremo i dati gradualmente

✅ **Sicurezza**:
- Il vecchio sistema usa AspNet Identity
- Il nuovo sistema usa JWT (più moderno e scalabile)
- Per ora convivono, poi migreremo tutto al nuovo

---

**Hai tutto pronto per testare!** 🚀

Se hai problemi durante il setup, fammi sapere a che punto sei bloccato.
