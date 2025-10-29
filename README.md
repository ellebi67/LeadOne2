# LeadOne2

Sistema moderno di gestione lead e progetti, costruito con ASP.NET Core 8 e React + TypeScript.

## 🏗️ Architettura

Il progetto segue il pattern **Clean Architecture** per garantire:
- ✅ Semplice manutenibilità
- ✅ Scalabilità
- ✅ Testabilità
- ✅ Separazione delle responsabilità

### Struttura del Progetto

```
LeadOne2/
├── src/
│   ├── LeadOne2.Core/              # Entità e interfacce
│   ├── LeadOne2.Application/       # Logica di business, DTOs, validatori
│   ├── LeadOne2.Infrastructure/    # Database, auth, repositories
│   ├── LeadOne2.Api/               # Web API REST
│   └── LeadOne2.Web/               # Frontend React + TypeScript
├── docs/                           # Documentazione
└── scripts/                        # Script utilità
```

## 🚀 Tecnologie Utilizzate

### Backend
- **ASP.NET Core 8** - Framework web
- **Entity Framework Core** - ORM per database
- **SQL Server** - Database
- **JWT Authentication** - Autenticazione stateless moderna
- **BCrypt** - Hashing password sicuro
- **FluentValidation** - Validazione input
- **Swagger** - Documentazione API

### Frontend
- **React 18** - Libreria UI
- **TypeScript** - Type safety
- **Vite** - Build tool veloce
- **TailwindCSS** - Styling utility-first
- **React Router** - Routing
- **Axios** - HTTP client

## 📋 Prerequisiti

- .NET 8 SDK
- Node.js 18+ e npm
- SQL Server 2019+

## 🔧 Setup

### 1. Configurazione Database

Modifica la connection string in `src/LeadOne2.Api/appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=your_server;Database=LeadOne2;User Id=your_user;Password=your_password;TrustServerCertificate=True;"
  }
}
```

### 2. Applicare Migrations

```bash
cd src/LeadOne2.Api
dotnet ef database update
```

### 3. Avviare il Backend

```bash
cd src/LeadOne2.Api
dotnet run
```

L'API sarà disponibile su: `http://localhost:5000`
Swagger UI: `http://localhost:5000/swagger`

### 4. Configurare il Frontend

```bash
cd src/LeadOne2.Web
npm install
npm install react-router-dom axios
npm install -D tailwindcss postcss autoprefixer
```

### 5. Avviare il Frontend

```bash
cd src/LeadOne2.Web
npm run dev
```

Il frontend sarà disponibile su: `http://localhost:5173`

## 🔑 Funzionalità Implementate

### ✅ Autenticazione
- Registrazione utenti
- Login con JWT
- Password hashing con BCrypt
- Protezione route (pubbliche/private)

### ✅ Gestione Utenti
- Creazione utenti
- Ruoli (User/Admin)
- Profilo utente

### ✅ Gestione Progetti
- Creazione progetti (solo Admin)
- Lista progetti per utente
- Assegnazione utenti a progetti
- Rimozione utenti da progetti

## 📚 API Endpoints

### Auth
- `POST /api/auth/login` - Login
- `POST /api/auth/register` - Registrazione
- `GET /api/auth/me` - Utente corrente

### Projects
- `GET /api/projects` - Tutti i progetti
- `GET /api/projects/my-projects` - Progetti dell'utente
- `GET /api/projects/{id}` - Progetto specifico
- `POST /api/projects` - Crea progetto (Admin)
- `PUT /api/projects/{id}` - Aggiorna progetto (Admin)
- `POST /api/projects/{projectId}/users/{userId}` - Assegna utente (Admin)
- `DELETE /api/projects/{projectId}/users/{userId}` - Rimuovi utente (Admin)

## 🔐 Sicurezza

- Password hashate con BCrypt
- JWT per autenticazione stateless
- CORS configurato
- Validazione input con FluentValidation
- SQL injection protection (EF Core parametrized queries)

## 🎨 UI/UX

- Design moderno e pulito
- Responsive (mobile-friendly)
- TailwindCSS per styling consistente
- Componenti riusabili
- Feedback visivo (loading, errori)
- Interfaccia in italiano

## 🛠️ Prossimi Step

1. Creare le migrations iniziali del database
2. Aggiungere primo utente admin
3. Implementare gestione Companies (da vecchio DB)
4. Implementare gestione People
5. Implementare gestione Calls
6. Integrazione con OpiVoice
7. Dashboard con statistiche
8. Export dati

## 📝 Note di Sviluppo

### Vantaggi della Clean Architecture
- **Core**: Contiene entità e interfacce, nessuna dipendenza esterna
- **Application**: Logica di business, dipende solo da Core
- **Infrastructure**: Implementazioni (DB, auth), dipende da Core
- **Api**: Entry point, dipende da tutto

### JWT vs Identity Framework
- JWT è stateless (scalabile, cloud-friendly)
- Nessuna dipendenza da Identity tables
- Token auto-contenuto con claims
- Facile integrazione con frontend SPA

## 🤝 Contribuire

Per contribuire al progetto:
1. Segui la Clean Architecture
2. Usa TypeScript strict mode
3. Valida sempre gli input
4. Scrivi codice leggibile e commentato
5. Testa le tue modifiche

## 📄 Licenza

Proprietario: LeadOne2 Project
