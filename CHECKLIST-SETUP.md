# ✅ Checklist Setup LeadOne2 (Database Esistente)

Setup rapido per testare LeadOne2 con il database **leadOne.Dev56** esistente.

## 📥 Step 1: Codice

- [ ] Clonato repository
- [ ] Branch corretto: `claude/session-011CUZxE2cL4HbvNoQbwQBGt`
- [ ] Aperto in VS Code / Visual Studio / Editor preferito

## ⚙️ Step 2: Configurazione

- [ ] Aperto `src/LeadOne2.Api/appsettings.json`
- [ ] Modificato connection string per puntare a `leadOne.Dev56`
- [ ] Testato connection string (opzionale):
  ```bash
  sqlcmd -S localhost -d leadOne.Dev56 -Q "SELECT DB_NAME()"
  ```

**Connection string esempio**:
```json
"Server=localhost;Database=leadOne.Dev56;Integrated Security=True;TrustServerCertificate=True;"
```

## 🗄️ Step 3: Database - Nuove Tabelle

**Scegli UN metodo**:

### Metodo A: Script SQL (più veloce)
- [ ] Aperto SQL Server Management Studio
- [ ] Connesso al database `leadOne.Dev56`
- [ ] Eseguito script `scripts/add-new-tables.sql`
- [ ] Verificato creazione tabelle:
  - Users
  - Projects
  - UserProjects
  - __EFMigrationsHistory

### Metodo B: EF Core Migrations
```bash
cd src/LeadOne2.Api
dotnet ef migrations add AddLeadOne2Tables --project ../LeadOne2.Infrastructure
dotnet ef database update
```

- [ ] Migration creata
- [ ] Migration applicata
- [ ] Nessun errore

## 🔧 Step 4: Backend

```bash
cd src/LeadOne2.Api
dotnet restore
dotnet build
```

- [ ] Restore completato
- [ ] Build succeeded (nessun errore)

```bash
dotnet run
```

- [ ] Backend avviato
- [ ] Output: `Now listening on: http://localhost:5000`
- [ ] Swagger accessibile: http://localhost:5000/swagger

## 🎨 Step 5: Frontend

**Nuovo terminale**:

```bash
cd src/LeadOne2.Web
npm install
```

- [ ] Dipendenze installate (può richiedere 2-3 minuti)
- [ ] Nessun errore

```bash
npm run dev
```

- [ ] Frontend avviato
- [ ] Output: `Local: http://localhost:5173/`
- [ ] Browser aperto su http://localhost:5173

## 👤 Step 6: Primo Utente

### Via Swagger: http://localhost:5000/swagger

- [ ] Aperto Swagger
- [ ] Espanso `POST /api/auth/register`
- [ ] Click "Try it out"
- [ ] Inserito JSON:
  ```json
  {
    "email": "admin@leadone.it",
    "password": "Admin123!",
    "name": "Admin",
    "surname": "LeadOne"
  }
  ```
- [ ] Click "Execute"
- [ ] Risposta 200 OK
- [ ] Copiato token dalla response

### Imposta come Admin

**In SQL Server Management Studio**:

```sql
USE [leadOne.Dev56]
UPDATE Users SET IsAdmin = 1 WHERE Email = 'admin@leadone.it'
SELECT * FROM Users WHERE Email = 'admin@leadone.it'
```

- [ ] Utente aggiornato a IsAdmin = 1
- [ ] Verificato con SELECT

## 🧪 Step 7: Test Login Frontend

- [ ] Aperto http://localhost:5173
- [ ] Visibile pagina di login
- [ ] Inserito:
  - Email: `admin@leadone.it`
  - Password: `Admin123!`
- [ ] Click "Accedi"
- [ ] Reindirizzato a pagina progetti
- [ ] Visibile nome utente e pulsante "Esci"

## 🎯 Step 8: Test Funzionalità Base

### Crea Progetto (solo Admin)

- [ ] Visibile pulsante "Crea Nuovo Progetto"
- [ ] Click sul pulsante
- [ ] Compilato form:
  - Nome: "Progetto Test"
  - Descrizione: "Primo progetto di prova"
- [ ] Salvato
- [ ] Progetto visibile nella lista

### Test API via Swagger

- [ ] Aperto http://localhost:5000/swagger
- [ ] Click lucchetto 🔒 "Authorize"
- [ ] Inserito: `Bearer YOUR_TOKEN` (il token copiato prima)
- [ ] Click "Authorize"
- [ ] Testato `GET /api/projects` → vedo il progetto creato
- [ ] Testato `GET /api/auth/me` → vedo i miei dati utente

## ✅ Verifica Finale

### Database
- [ ] Tabelle LeadOne2 create (Users, Projects, UserProjects)
- [ ] Tabelle LeadOne1 esistenti ancora presenti (AspNetUsers, Companies, etc.)
- [ ] Almeno 1 utente nella tabella Users
- [ ] Almeno 1 progetto nella tabella Projects

### Backend
- [ ] In esecuzione su http://localhost:5000
- [ ] Swagger accessibile
- [ ] API rispondono correttamente

### Frontend
- [ ] In esecuzione su http://localhost:5173
- [ ] Login funzionante
- [ ] Pagina progetti visibile
- [ ] Navigazione fluida

## 🎉 Setup Completato!

Se tutto è ✅:

**Ora puoi**:
1. Creare più utenti
2. Creare più progetti
3. Testare assegnazioni utenti-progetti
4. Esplorare il codice
5. Decidere quali funzionalità implementare dopo

**Prossimi step** (vedi `docs/NEXT_STEPS.md`):
- Implementare Companies (collegare a tabelle esistenti)
- Implementare People
- Implementare Calls
- Integrare OpiVoice (quando hai la documentazione)

## 🐛 Problemi?

Se qualcosa non funziona, consulta:
- `docs/QUICK-TEST.md` → Troubleshooting dettagliato
- `docs/QUICKSTART.md` → Guida completa
- Console backend (per errori server)
- Browser DevTools F12 (per errori frontend)

### Problemi Comuni

**Backend non si avvia**:
```bash
# Verifica .NET
dotnet --version  # Deve essere >= 8.0

# Verifica connection string
# In appsettings.json punta a leadOne.Dev56?
```

**Frontend non si connette**:
```bash
# Verifica in src/LeadOne2.Web/src/services/api.ts
# L'URL deve essere: http://localhost:5000/api
```

**Login non funziona**:
```sql
-- Verifica utente nel DB
USE [leadOne.Dev56]
SELECT * FROM Users WHERE Email = 'admin@leadone.it'
-- IsActive deve essere 1
-- IsAdmin deve essere 1 (per creare progetti)
```

---

**Buon test!** 🚀

Per domande o problemi, fammi sapere a che punto della checklist sei bloccato.
