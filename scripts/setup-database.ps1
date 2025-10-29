# Script di Setup Database per LeadOne2 (Windows)
# Eseguire da: \LeadOne2\
# PowerShell: .\scripts\setup-database.ps1

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   LeadOne2 - Database Setup Script" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Controlla .NET SDK
Write-Host "1. Verifico .NET SDK..." -ForegroundColor Yellow
try {
    $dotnetVersion = dotnet --version
    Write-Host "✅ .NET SDK versione: $dotnetVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ .NET SDK non trovato!" -ForegroundColor Red
    Write-Host "Installa .NET 8 SDK da: https://dotnet.microsoft.com/download/dotnet/8.0" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Controlla EF Core Tools
Write-Host "2. Verifico Entity Framework Core Tools..." -ForegroundColor Yellow
$efTools = dotnet tool list -g | Select-String "dotnet-ef"
if (-not $efTools) {
    Write-Host "⚠️  EF Core Tools non installato, installazione in corso..." -ForegroundColor Yellow
    dotnet tool install --global dotnet-ef
    Write-Host "✅ EF Core Tools installato" -ForegroundColor Green
} else {
    $efVersion = dotnet ef --version | Select-Object -First 1
    Write-Host "✅ EF Core Tools trovato: $efVersion" -ForegroundColor Green
}
Write-Host ""

# Verifica connection string
Write-Host "3. Verifico configurazione database..." -ForegroundColor Yellow
$appSettings = Get-Content "src\LeadOne2.Api\appsettings.json" -Raw
if ($appSettings -match "DefaultConnection") {
    Write-Host "✅ Connection string configurata in appsettings.json" -ForegroundColor Green
    Write-Host "⚠️  Assicurati che sia corretta prima di continuare!" -ForegroundColor Yellow
} else {
    Write-Host "❌ Connection string non trovata!" -ForegroundColor Red
    exit 1
}
Write-Host ""
Read-Host "Premere INVIO per continuare"
Write-Host ""

# Navigazione al progetto API
Set-Location "src\LeadOne2.Api"

# Verifica se esistono già migrations
Write-Host "4. Verifico migrations esistenti..." -ForegroundColor Yellow
if (Test-Path "..\LeadOne2.Infrastructure\Migrations") {
    Write-Host "⚠️  Cartella Migrations già esistente" -ForegroundColor Yellow
    $recreate = Read-Host "Vuoi ricreare le migrations? (s/N)"
    if ($recreate -eq "s" -or $recreate -eq "S") {
        Write-Host "Rimuovo migrations esistenti..." -ForegroundColor Yellow
        Remove-Item "..\LeadOne2.Infrastructure\Migrations" -Recurse -Force
        Write-Host "✅ Migrations rimosse" -ForegroundColor Green
    }
}
Write-Host ""

# Crea migration iniziale
Write-Host "5. Creo migration iniziale..." -ForegroundColor Yellow
dotnet ef migrations add InitialCreate --project ..\LeadOne2.Infrastructure --startup-project . --verbose

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Migration 'InitialCreate' creata con successo" -ForegroundColor Green
} else {
    Write-Host "❌ Errore durante la creazione della migration" -ForegroundColor Red
    Set-Location ..\..
    exit 1
}
Write-Host ""

# Applica migration al database
Write-Host "6. Applico migration al database..." -ForegroundColor Yellow
Write-Host "⚠️  Questo creerà il database e le tabelle" -ForegroundColor Yellow
$apply = Read-Host "Continuare? (S/n)"
if ($apply -ne "n" -and $apply -ne "N") {
    dotnet ef database update --verbose

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Database creato e aggiornato con successo" -ForegroundColor Green
    } else {
        Write-Host "❌ Errore durante l'aggiornamento del database" -ForegroundColor Red
        Set-Location ..\..
        exit 1
    }
} else {
    Write-Host "Operazione annullata" -ForegroundColor Yellow
    Set-Location ..\..
    exit 0
}
Write-Host ""

# Torna alla directory root
Set-Location ..\..

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "✅ Setup Database Completato!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Prossimi passi:" -ForegroundColor Yellow
Write-Host "1. Avvia il backend: cd src\LeadOne2.Api && dotnet run" -ForegroundColor White
Write-Host "2. Crea utente admin tramite Swagger: http://localhost:5000/swagger" -ForegroundColor White
Write-Host "3. Testa il frontend: cd src\LeadOne2.Web && npm run dev" -ForegroundColor White
Write-Host ""
Write-Host "Script per creare l'admin disponibile in: scripts\create-admin.ps1" -ForegroundColor Cyan
Write-Host ""
