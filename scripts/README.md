# Scripts - LeadOne2

Collezione di script per setup, test e manutenzione del sistema.

## 🚀 Setup Scripts

### `setup-database.sh` / `setup-database.ps1`
Script automatico per la configurazione iniziale del database.

**Cosa fa**:
1. Verifica prerequisiti (.NET SDK, EF Core Tools)
2. Crea migration iniziale
3. Applica migration e crea database
4. Crea tabelle

**Utilizzo**:
```bash
# Linux/Mac
./scripts/setup-database.sh

# Windows PowerShell
.\scripts\setup-database.ps1
```

## 🧪 Test Scripts

### `test-commands.sh`
Script di test automatico delle API usando cURL.

**Cosa fa**:
1. Verifica che il backend sia in esecuzione
2. Registra un utente di test
3. Testa login e recupero utente
4. Testa lista progetti
5. Testa creazione progetto (se admin)
6. Salva token per uso successivo

**Prerequisiti**:
- Backend in esecuzione su http://localhost:5000
- `jq` installato (per parsing JSON)

**Utilizzo**:
```bash
# Avvia prima il backend
cd src/LeadOne2.Api && dotnet run &

# In un altro terminale
./scripts/test-commands.sh
```

### `test-api.http`
File HTTP per testare le API con REST Client (VS Code) o Postman.

**Utilizzo**:
1. Installa extension "REST Client" in VS Code
2. Apri `test-api.http`
3. Click su "Send Request" sopra ogni richiesta

**Oppure con Postman**:
1. Importa il file in Postman
2. Esegui le richieste in sequenza

## 🗄️ Database Scripts

### `create-admin.sql`
Crea un utente admin direttamente nel database.

**⚠️ Nota**: È meglio usare Swagger per registrare l'utente, poi questo script SQL solo per impostare IsAdmin = 1.

**Utilizzo**:
```sql
-- Da SQL Server Management Studio o sqlcmd
USE LeadOne2;
-- Modifica lo script con email/nome desiderati
-- Esegui lo script
```

### `verify-database.sql`
Verifica che il database sia stato creato correttamente.

**Cosa fa**:
1. Lista tutte le tabelle
2. Conta record in ogni tabella
3. Mostra utenti registrati
4. Mostra progetti creati

**Utilizzo**:
```sql
-- Da SSMS
-- Apri verify-database.sql
-- Esegui (F5)

-- Da command line
sqlcmd -S localhost -d LeadOne2 -i scripts/verify-database.sql
```

## 📁 Struttura File

```
scripts/
├── README.md                    # Questo file
├── setup-database.sh           # Setup DB (Linux/Mac)
├── setup-database.ps1          # Setup DB (Windows)
├── test-commands.sh            # Test automatici API (cURL)
├── test-api.http              # Test API (REST Client)
├── create-admin.sql           # Crea utente admin
└── verify-database.sql        # Verifica database
```

## 🔧 Manutenzione Scripts (Future)

Questi script saranno aggiunti successivamente:

### `migrate-from-leadone1.sql`
Script per migrare dati da LeadOne 1 a LeadOne2.

### `backup-database.sh`
Backup automatico del database.

### `seed-data.sql`
Popola il database con dati di esempio per testing.

### `reset-database.sh`
Reset completo del database (DROP + CREATE + MIGRATE).

## 💡 Tips

### Salvare il Token JWT
Il test script salva automaticamente il token in `/tmp/leadone2_token.txt`:

```bash
# Usa il token salvato
export TOKEN=$(cat /tmp/leadone2_token.txt)

# Test rapido
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:5000/api/projects
```

### Test Rapidi con jq
```bash
# Lista solo i nomi dei progetti
curl -s -H "Authorization: Bearer $TOKEN" \
  http://localhost:5000/api/projects | jq '.[].name'

# Conta progetti
curl -s -H "Authorization: Bearer $TOKEN" \
  http://localhost:5000/api/projects | jq 'length'
```

### Impostare Utente come Admin
```bash
# Via SQL
sqlcmd -S localhost -d LeadOne2 -Q \
  "UPDATE Users SET IsAdmin = 1 WHERE Email = 'user@example.com'"

# Oppure apri SSMS ed esegui:
# UPDATE Users SET IsAdmin = 1 WHERE Email = 'user@example.com';
```

## 🐛 Troubleshooting

### Script non eseguibile
```bash
chmod +x scripts/*.sh
```

### jq non trovato
```bash
# Ubuntu/Debian
sudo apt-get install jq

# Mac
brew install jq

# Windows
# Download da: https://stedolan.github.io/jq/download/
```

### sqlcmd non trovato
```bash
# Installa SQL Server Command Line Tools
# https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility
```

## 📚 Documentazione Correlata

- `docs/QUICKSTART.md` - Guida setup manuale completa
- `docs/SETUP.md` - Setup dettagliato del progetto
- `docs/NEXT_STEPS.md` - Prossime funzionalità da implementare
- `README.md` - Panoramica del progetto

---

**Per domande o problemi**: Consulta la documentazione in `docs/` o i log del backend/frontend.
