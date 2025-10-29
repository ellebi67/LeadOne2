# 🚀 Quick Start - LeadOne2

Guida rapida per setup e primo test del sistema.

## ⚡ Setup Automatico (Raccomandato)

### Windows (PowerShell)
```powershell
# Dalla cartella LeadOne2
.\scripts\setup-database.ps1
```

### Linux/Mac (Bash)
```bash
# Dalla cartella LeadOne2
chmod +x scripts/setup-database.sh
./scripts/setup-database.sh
```

## 📋 Setup Manuale (Passo-Passo)

### 1. Prerequisiti

Verifica di avere installato:

```bash
# .NET SDK
dotnet --version
# Deve essere >= 8.0

# Node.js
node --version
# Deve essere >= 18.0

# npm
npm --version
```

Se manca qualcosa:
- **.NET 8**: https://dotnet.microsoft.com/download/dotnet/8.0
- **Node.js**: https://nodejs.org/ (LTS version)

### 2. Configura Connection String

Apri `src/LeadOne2.Api/appsettings.json` e modifica:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=YOUR_SERVER;Database=LeadOne2;User Id=YOUR_USER;Password=YOUR_PASSWORD;TrustServerCertificate=True;"
  }
}
```

**Esempi comuni**:

```json
// SQL Server locale con autenticazione Windows
"Server=localhost;Database=LeadOne2;Integrated Security=True;TrustServerCertificate=True;"

// SQL Server locale con autenticazione SQL
"Server=localhost;Database=LeadOne2;User Id=sa;Password=YourPassword123!;TrustServerCertificate=True;"

// SQL Server Express
"Server=localhost\\SQLEXPRESS;Database=LeadOne2;Integrated Security=True;TrustServerCertificate=True;"

// SQL Server remoto
"Server=192.168.1.100;Database=LeadOne2;User Id=leadone_user;Password=YourPassword;TrustServerCertificate=True;"
```

### 3. Installa EF Core Tools

```bash
dotnet tool install --global dotnet-ef

# Verifica installazione
dotnet ef --version
```

### 4. Crea Database con Migrations

```bash
cd src/LeadOne2.Api

# Crea migration
dotnet ef migrations add InitialCreate --project ../LeadOne2.Infrastructure --startup-project . --verbose

# Applica migration (crea database e tabelle)
dotnet ef database update --verbose
```

**Output atteso**:
```
Build started...
Build succeeded.
info: Microsoft.EntityFrameworkCore.Database.Command[20101]
      Executed DbCommand (XXms) [Parameters=[], CommandType='Text']
      CREATE DATABASE [LeadOne2];
...
Done.
```

### 5. Verifica Database Creato

#### Opzione A: SQL Server Management Studio (SSMS)
1. Apri SSMS
2. Connettiti al server
3. Cerca il database `LeadOne2`
4. Espandi "Tables" - dovresti vedere:
   - Users
   - Projects
   - UserProjects
   - __EFMigrationsHistory

#### Opzione B: Query SQL
Esegui lo script: `scripts/verify-database.sql`

### 6. Avvia Backend

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

### 7. Testa con Swagger

Apri browser su: **http://localhost:5000/swagger**

Dovresti vedere l'interfaccia Swagger con:
- `/api/auth/login`
- `/api/auth/register`
- `/api/auth/me`
- `/api/projects/*`

## 👤 Crea Primo Utente Admin

### Opzione A: Tramite Swagger (Raccomandato)

1. Vai su **http://localhost:5000/swagger**
2. Espandi `POST /api/auth/register`
3. Click su "Try it out"
4. Inserisci i dati:

```json
{
  "email": "admin@leadone.it",
  "password": "Admin123!",
  "name": "Admin",
  "surname": "LeadOne"
}
```

5. Click "Execute"
6. Copia il **token** dalla response (servirà dopo)
7. Verifica la response:

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "admin@leadone.it",
    "name": "Admin",
    "surname": "LeadOne",
    "isAdmin": false
  }
}
```

### Imposta come Admin

L'utente creato tramite registrazione è un utente normale. Per renderlo Admin:

#### Opzione 1: Via SQL (Veloce)
```sql
USE LeadOne2;
UPDATE Users SET IsAdmin = 1 WHERE Email = 'admin@leadone.it';
SELECT * FROM Users WHERE Email = 'admin@leadone.it';
```

#### Opzione 2: Via Swagger (se hai già un admin)
- Usa un token admin per modificare l'utente

### Opzione B: Tramite SQL Diretto

Esegui lo script: `scripts/create-admin.sql`

**⚠️ NOTA**: Questo script richiede un hash BCrypt valido. È meglio usare Swagger.

## 🧪 Test delle API

### Test 1: Login

In Swagger:
1. Espandi `POST /api/auth/login`
2. Try it out
3. Inserisci:

```json
{
  "email": "admin@leadone.it",
  "password": "Admin123!"
}
```

4. Execute
5. **Copia il token** dalla response

### Test 2: Verifica Utente Corrente

1. Espandi `GET /api/auth/me`
2. Click sul lucchetto 🔒 in alto a destra (Authorize)
3. Inserisci: `Bearer YOUR_TOKEN_HERE`
4. Click "Authorize"
5. Try it out su `/api/auth/me`
6. Execute
7. Dovresti vedere i tuoi dati utente

### Test 3: Crea Progetto (Solo Admin)

1. **Assicurati** che l'utente sia Admin (vedi sopra)
2. Espandi `POST /api/projects`
3. Try it out
4. Inserisci:

```json
{
  "name": "Progetto Demo",
  "description": "Primo progetto di test"
}
```

5. Execute
6. Verifica la response:

```json
{
  "id": 1,
  "name": "Progetto Demo",
  "description": "Primo progetto di test",
  "isActive": true,
  "createdAt": "2025-10-29T..."
}
```

### Test 4: Lista Progetti

1. Espandi `GET /api/projects`
2. Execute
3. Dovresti vedere il progetto creato

## 🎨 Test Frontend

### 1. Installa Dipendenze (se non fatto)

```bash
cd src/LeadOne2.Web
npm install
```

### 2. Avvia Frontend

```bash
npm run dev
```

**Output atteso**:
```
  VITE v7.x.x  ready in XXX ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
```

### 3. Apri Browser

Vai su: **http://localhost:5173**

### 4. Test Login

1. Dovresti vedere la pagina di login
2. Inserisci:
   - Email: `admin@leadone.it`
   - Password: `Admin123!`
3. Click "Accedi"
4. Dovresti essere reindirizzato alla pagina progetti

### 5. Test Progetti

- Verifica che vedi la lista progetti
- Se sei Admin, dovresti vedere il pulsante "Crea Nuovo Progetto"

## ✅ Checklist Verifica

- [ ] Database `LeadOne2` creato
- [ ] Tabelle create (Users, Projects, UserProjects)
- [ ] Backend avviato su http://localhost:5000
- [ ] Swagger accessibile su http://localhost:5000/swagger
- [ ] Utente admin creato
- [ ] Login funzionante su Swagger
- [ ] API progetti funzionanti
- [ ] Frontend avviato su http://localhost:5173
- [ ] Login frontend funzionante
- [ ] Pagina progetti visibile

## 🐛 Troubleshooting

### Errore: "Cannot connect to database"

**Causa**: Connection string errata o SQL Server non in esecuzione

**Soluzione**:
```bash
# Verifica SQL Server sia in esecuzione
# Windows: Apri Services → SQL Server (MSSQLSERVER) → Start

# Testa connection string con sqlcmd
sqlcmd -S YOUR_SERVER -U YOUR_USER -P YOUR_PASSWORD -Q "SELECT @@VERSION"
```

### Errore: "Migration already exists"

**Causa**: Migrations già presenti

**Soluzione**:
```bash
cd src/LeadOne2.Api

# Rimuovi migrations esistenti
rm -rf ../LeadOne2.Infrastructure/Migrations

# Ricrea
dotnet ef migrations add InitialCreate --project ../LeadOne2.Infrastructure
```

### Errore: "CORS policy"

**Causa**: Backend non in esecuzione o URL errato

**Soluzione**:
1. Verifica backend su http://localhost:5000
2. Verifica `src/LeadOne2.Web/src/services/api.ts`:
   ```typescript
   const API_URL = 'http://localhost:5000/api';
   ```

### Errore: "Unauthorized" su API

**Causa**: Token JWT mancante o scaduto

**Soluzione**:
1. Fai login di nuovo
2. Copia il nuovo token
3. Click su 🔒 Authorize in Swagger
4. Inserisci: `Bearer YOUR_NEW_TOKEN`

### Frontend non si avvia

**Soluzione**:
```bash
cd src/LeadOne2.Web

# Pulisci e reinstalla
rm -rf node_modules package-lock.json
npm install

# Riavvia
npm run dev
```

## 📞 Supporto

Se hai problemi:

1. **Controlla i log**: Console del backend e del frontend
2. **Verifica Swagger**: Testa le API direttamente
3. **Browser DevTools**: F12 → Console/Network per errori frontend
4. **Database**: Verifica con query SQL che i dati siano corretti

## 🎯 Prossimi Step

Una volta completato il setup:

1. **Crea più utenti**: Per testare assegnazioni
2. **Crea più progetti**: Per testare la lista
3. **Testa assegnazione**: Assegna utenti a progetti
4. **Esplora il codice**: Familiarizza con l'architettura

Leggi: `docs/NEXT_STEPS.md` per le prossime funzionalità da implementare.

---

**Buon divertimento con LeadOne2!** 🚀
