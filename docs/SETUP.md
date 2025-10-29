# Guida Setup Completa LeadOne2

## 1. Installazione Prerequisiti

### Windows

#### .NET 8 SDK
1. Scarica da: https://dotnet.microsoft.com/download/dotnet/8.0
2. Installa il SDK (non solo il runtime)
3. Verifica: `dotnet --version`

#### Node.js
1. Scarica da: https://nodejs.org/ (versione LTS)
2. Installa con npm incluso
3. Verifica: `node --version` e `npm --version`

#### SQL Server
- SQL Server 2019+ o SQL Server Express
- SQL Server Management Studio (SSMS) consigliato

### Linux/Mac

#### .NET 8 SDK
```bash
# Ubuntu/Debian
wget https://dot.net/v1/dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --channel 8.0

# Mac
brew install dotnet-sdk
```

#### Node.js
```bash
# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Mac
brew install node
```

## 2. Clone e Build Backend

### Clona il Repository
```bash
git clone [your-repo-url]
cd LeadOne2
```

### Restore Pacchetti .NET
```bash
cd src/LeadOne2.Api
dotnet restore
dotnet build
```

## 3. Configurazione Database

### Crea Database SQL Server

#### Opzione A: Con SSMS (Windows)
1. Apri SQL Server Management Studio
2. Connettiti al server
3. Click destro su "Databases" → "New Database"
4. Nome: `LeadOne2`
5. OK

#### Opzione B: Con Query
```sql
CREATE DATABASE LeadOne2;
GO
```

### Configura Connection String

Modifica `src/LeadOne2.Api/appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=LeadOne2;User Id=sa;Password=YourPassword123!;TrustServerCertificate=True;"
  }
}
```

**Nota**: Adatta i parametri al tuo setup:
- `Server`: nome del server SQL
- `User Id`: username SQL
- `Password`: password SQL

### Crea le Migrations e Aggiorna il Database

```bash
cd src/LeadOne2.Api

# Installa EF Core tools se necessario
dotnet tool install --global dotnet-ef

# Crea la prima migration
dotnet ef migrations add InitialCreate --project ../LeadOne2.Infrastructure --startup-project .

# Applica al database
dotnet ef database update
```

## 4. Configurazione Frontend

### Installa Dipendenze
```bash
cd src/LeadOne2.Web
npm install
```

### Installa Pacchetti Aggiuntivi
```bash
npm install react-router-dom axios
npm install -D tailwindcss postcss autoprefixer
```

### Verifica File di Configurazione
Assicurati che esistano:
- `tailwind.config.js`
- `postcss.config.js`
- `vite.config.ts`

## 5. Prima Esecuzione

### Avvia Backend
```bash
cd src/LeadOne2.Api
dotnet run
```

Verifica che l'API sia attiva:
- API: http://localhost:5000
- Swagger: http://localhost:5000/swagger

### Avvia Frontend (nuovo terminale)
```bash
cd src/LeadOne2.Web
npm run dev
```

Apri il browser su: http://localhost:5173

## 6. Crea Primo Utente Admin

### Opzione A: Via Swagger
1. Vai su http://localhost:5000/swagger
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
5. Execute
6. Copia il token dalla response

### Opzione B: Directly nel DB (per settare come Admin)
```sql
USE LeadOne2;

-- Trova l'utente
SELECT * FROM Users WHERE Email = 'admin@leadone.it';

-- Rendilo Admin
UPDATE Users SET IsAdmin = 1 WHERE Email = 'admin@leadone.it';
```

## 7. Test dell'Applicazione

### Test Login
1. Vai su http://localhost:5173
2. Clicca "Accedi"
3. Usa le credenziali:
   - Email: `admin@leadone.it`
   - Password: `Admin123!`
4. Dovresti essere reindirizzato alla pagina progetti

### Test Creazione Progetto (Admin)
1. Loggato come admin
2. Click "Crea Nuovo Progetto"
3. Compila i dati
4. Salva

## 8. Troubleshooting

### Errore: "Unable to connect to the database"
- Verifica che SQL Server sia in esecuzione
- Controlla la connection string
- Verifica username e password

### Errore: "CORS policy"
- Verifica che il backend sia in esecuzione su `localhost:5000`
- Controlla la configurazione CORS in `Program.cs`

### Errore: "Cannot find module"
```bash
cd src/LeadOne2.Web
rm -rf node_modules package-lock.json
npm install
```

### Errore: "Migration already applied"
```bash
dotnet ef database drop --force
dotnet ef database update
```

### Frontend non si connette all'API
- Verifica che l'URL in `src/services/api.ts` sia `http://localhost:5000/api`
- Controlla che il backend sia in esecuzione
- Ispeziona la console browser (F12) per errori

## 9. Deployment su Server

### Backend
1. Pubblica l'applicazione:
```bash
cd src/LeadOne2.Api
dotnet publish -c Release -o ./publish
```

2. Copia la cartella `publish` sul server
3. Configura IIS o usa Kestrel direttamente
4. Aggiorna `appsettings.json` con connection string di produzione

### Frontend
```bash
cd src/LeadOne2.Web
npm run build
```

La cartella `dist` contiene i file statici da deployare su:
- IIS
- Nginx
- Apache
- Servizi cloud (Azure, AWS, etc.)

## 10. Variabili d'Ambiente

### Produzione - Backend
Crea `appsettings.Production.json`:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-production-connection-string"
  },
  "JwtSettings": {
    "SecretKey": "change-this-to-a-secure-random-key-at-least-32-chars",
    "ExpirationMinutes": "1440"
  }
}
```

### Produzione - Frontend
Crea `.env.production`:
```
VITE_API_URL=https://your-api-domain.com/api
```

## 📞 Supporto

Per problemi di setup, controlla:
1. Logs del backend nella console
2. Console browser (F12) per errori frontend
3. Swagger per testare API direttamente
4. Database per verificare dati inseriti
