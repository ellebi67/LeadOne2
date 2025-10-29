# Prossimi Step - LeadOne2

## ✅ Completato

1. **Architettura Base**
   - Clean Architecture implementata
   - Separazione layer (Core, Application, Infrastructure, API)
   - Frontend React con TypeScript
   - Sistema autenticazione JWT

2. **Funzionalità Base**
   - Login/Registrazione utenti
   - Gestione progetti
   - Assegnazione utenti a progetti
   - UI moderna con TailwindCSS

## 🚀 Prossime Implementazioni (in ordine di priorità)

### 1. Database Setup e Migrations
**Priority: ALTA**
```bash
# Creare le migrations
cd src/LeadOne2.Api
dotnet ef migrations add InitialCreate --project ../LeadOne2.Infrastructure
dotnet ef database update
```

Cosa fare:
- [ ] Configurare connection string per il tuo SQL Server
- [ ] Creare database LeadOne2
- [ ] Applicare migrations
- [ ] Creare primo utente admin via SQL o Swagger

### 2. Migrazione Dati da LeadOne 1
**Priority: ALTA**

Basandoti sullo schema SQL fornito, devi:

#### 2.1 Mappare entità esistenti
- [ ] **Companies** (leadOne.Dev56) → **Companies** (LeadOne2)
- [ ] **People** → **People**
- [ ] **Calls** → **Calls**
- [ ] **Appointments** → **Appointments**
- [ ] **AspNetUsers** (vecchio) → **Users** (nuovo con JWT)

#### 2.2 Creare script di migrazione
Creare in `scripts/migration/`:
```sql
-- scripts/migration/01_migrate_companies.sql
-- scripts/migration/02_migrate_people.sql
-- scripts/migration/03_migrate_users.sql
-- scripts/migration/04_migrate_calls.sql
```

#### 2.3 Entità da aggiungere al nuovo sistema
Le seguenti entità dal vecchio DB vanno implementate:

**Companies** (già nel vecchio DB):
- Aziende con tutti i dettagli fiscali
- Stati aziende progetto
- Lock aziende
- Custom data

**People** (già nel vecchio DB):
- Persone di contatto
- Ruoli contatto
- Lock persone
- Relazioni tra persone

**Calls** (già nel vecchio DB):
- Chiamate con risultati
- Esiti chiamata

**Appointments** (già nel vecchio DB):
- Appuntamenti
- Risultati appuntamenti
- Tipi appuntamento

**Recalls**:
- Richiami/promemoria

**Nations**:
- Gestione nazioni multi-lingua

### 3. Implementare Entità Mancanti
**Priority: ALTA**

#### 3.1 Companies
```bash
# Creare in LeadOne2.Core/Entities/
- Company.cs
- CompanyProject.cs
- CompanyLock.cs
- CustomData.cs
```

#### 3.2 People & Contacts
```bash
- Person.cs
- ContactRole.cs
- PersonCompany.cs
- PersonLock.cs
```

#### 3.3 Calls & Appointments
```bash
- Call.cs
- CallResult.cs (enum)
- Appointment.cs
- AppointmentResult.cs
- AppointmentType.cs
```

### 4. Integrazione OpiVoice
**Priority: MEDIA**

Una volta che hai la documentazione API di OpiVoice:

- [ ] Creare `OpiVoiceService` in Infrastructure
- [ ] Implementare chiamate alle API OpiVoice
- [ ] Sincronizzazione dati chiamate
- [ ] Gestione stato chiamate in tempo reale

Struttura suggerita:
```csharp
// LeadOne2.Infrastructure/Services/OpiVoiceService.cs
public interface IOpiVoiceService
{
    Task<CallStatus> GetCallStatusAsync(string callId);
    Task<bool> InitiateCallAsync(string phoneNumber);
    // altre operazioni
}
```

### 5. Dashboard e Statistiche
**Priority: MEDIA**

- [ ] Conteggio chiamate per operatore
- [ ] Conteggio appuntamenti fissati
- [ ] Statistiche conversione
- [ ] Grafici andamento (Chart.js o Recharts)

### 6. Gestione Completa Companies
**Priority: ALTA**

#### Frontend:
- [ ] Pagina lista aziende con filtri
- [ ] Dettaglio azienda
- [ ] Modifica azienda
- [ ] Import aziende da CSV/Excel
- [ ] Export aziende

#### Backend:
- [ ] CompaniesController con CRUD completo
- [ ] CompanyService con logica business
- [ ] Filtri avanzati (settore, fatturato, dipendenti, etc.)
- [ ] Paginazione e ordinamento
- [ ] Lock/Unlock aziende

### 7. Gestione People
**Priority: ALTA**

- [ ] CRUD persone
- [ ] Associazione persone-aziende
- [ ] Ruoli contatto
- [ ] Storico interazioni

### 8. Gestione Calls & Appointments
**Priority: ALTA**

- [ ] Registrazione chiamate
- [ ] Fissare appuntamenti
- [ ] Calendario appuntamenti
- [ ] Promemoria automatici
- [ ] Esiti e note

### 9. Sistema di Lock
**Priority: MEDIA**

Implementare il sistema di lock per evitare modifiche concorrenti:
- [ ] Lock automatico quando un operatore apre un'azienda/persona
- [ ] Timeout automatico (es. dopo 15 minuti)
- [ ] Indicatore visivo se qualcuno sta lavorando su un record
- [ ] Force unlock per admin

### 10. Custom Data & Filtri
**Priority: BASSA**

- [ ] Gestione campi custom per progetto
- [ ] Filtri salvati per utente
- [ ] Export con campi custom

### 11. Multi-Tenant / Multi-Project
**Priority: MEDIA**

- [ ] Isolamento dati per progetto
- [ ] Gestione permessi per progetto
- [ ] Switch progetti nell'UI

### 12. Reportistica
**Priority: BASSA**

- [ ] Report chiamate per periodo
- [ ] Report appuntamenti
- [ ] Report conversioni
- [ ] Export PDF/Excel

### 13. Notifiche
**Priority: BASSA**

- [ ] Notifiche in-app
- [ ] Email per appuntamenti
- [ ] Promemoria richiami
- [ ] SignalR per notifiche real-time

### 14. Testing
**Priority: MEDIA**

- [ ] Unit test per services
- [ ] Integration test per API
- [ ] End-to-end test frontend (Playwright/Cypress)

### 15. Deploy & DevOps
**Priority: BASSA (quando pronto per produzione)**

- [ ] Docker containers
- [ ] CI/CD pipeline
- [ ] Backup automatici database
- [ ] Monitoring e logging (Application Insights)
- [ ] SSL/HTTPS setup

## 📋 Checklist Immediata (Questa Settimana)

1. **Setup Database**
   - [ ] Configura SQL Server
   - [ ] Applica migrations
   - [ ] Crea utente admin

2. **Test Funzionalità Base**
   - [ ] Testa registrazione utente
   - [ ] Testa login
   - [ ] Testa creazione progetto
   - [ ] Testa assegnazione utente a progetto

3. **Analisi Schema Vecchio**
   - [ ] Documenta tutte le entità del vecchio DB
   - [ ] Identifica quali mantenere
   - [ ] Identifica quali semplificare

4. **Pianifica Migrazione**
   - [ ] Script SQL per migrazione dati
   - [ ] Piano di test migrazione
   - [ ] Backup database vecchio

## 📞 Informazioni da Fornire

Per continuare in modo efficace, ho bisogno di:

1. **API OpiVoice**
   - Documentazione endpoint
   - Esempi di chiamate
   - Autenticazione richiesta

2. **Requisiti Specifici**
   - Workflow operatori (step by step)
   - Priorità funzionalità
   - Numero utenti previsti
   - Volume dati

3. **Decisioni Architetturali**
   - Quali entità dal vecchio DB mantenere
   - Quali semplificare
   - Nuove funzionalità desiderate

## 🎯 Obiettivo Finale

Sistema completo e funzionale che:
- ✅ Gestisce utenti e progetti
- ✅ Gestisce aziende e contatti
- ✅ Registra chiamate e appuntamenti
- ✅ Si integra con OpiVoice
- ✅ Fornisce statistiche e report
- ✅ È scalabile e manutenibile
- ✅ Ha un'interfaccia moderna e intuitiva

## 💡 Consigli

1. **Procedi incrementalmente**: Implementa una feature alla volta e testala
2. **Mantieni il focus**: Prima le funzionalità core, poi quelle accessorie
3. **Testa continuamente**: Meglio trovare bug subito che in produzione
4. **Documenta**: Ogni nuova funzionalità va documentata
5. **Versiona**: Usa git per tracciare tutte le modifiche
6. **Comunica**: Mantienimi aggiornato sui progressi e blocchi

---

**Prossima Sessione**: Fammi sapere quale di questi step vuoi affrontare per primo!
