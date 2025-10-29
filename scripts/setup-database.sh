#!/bin/bash
# Script di Setup Database per LeadOne2
# Eseguire da: /LeadOne2/

set -e  # Exit on error

echo "=========================================="
echo "   LeadOne2 - Database Setup Script"
echo "=========================================="
echo ""

# Colori per output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Controlla .NET SDK
echo "1. Verifico .NET SDK..."
if ! command -v dotnet &> /dev/null; then
    echo -e "${RED}❌ .NET SDK non trovato!${NC}"
    echo "Installa .NET 8 SDK da: https://dotnet.microsoft.com/download/dotnet/8.0"
    exit 1
fi

DOTNET_VERSION=$(dotnet --version)
echo -e "${GREEN}✅ .NET SDK versione: $DOTNET_VERSION${NC}"
echo ""

# Controlla EF Core Tools
echo "2. Verifico Entity Framework Core Tools..."
if ! dotnet tool list -g | grep -q "dotnet-ef"; then
    echo -e "${YELLOW}⚠️  EF Core Tools non installato, installazione in corso...${NC}"
    dotnet tool install --global dotnet-ef
    echo -e "${GREEN}✅ EF Core Tools installato${NC}"
else
    EF_VERSION=$(dotnet ef --version | head -n 1)
    echo -e "${GREEN}✅ EF Core Tools trovato: $EF_VERSION${NC}"
fi
echo ""

# Verifica connection string
echo "3. Verifico configurazione database..."
CONN_STRING=$(grep "DefaultConnection" src/LeadOne2.Api/appsettings.json || echo "")
if [[ -z "$CONN_STRING" ]]; then
    echo -e "${RED}❌ Connection string non trovata!${NC}"
    exit 1
fi

echo -e "${YELLOW}Connection string configurata in appsettings.json${NC}"
echo -e "${YELLOW}⚠️  Assicurati che sia corretta prima di continuare!${NC}"
echo ""
read -p "Premere INVIO per continuare..."
echo ""

# Navigazione al progetto API
cd src/LeadOne2.Api

# Verifica se esistono già migrations
echo "4. Verifico migrations esistenti..."
if [ -d "../LeadOne2.Infrastructure/Migrations" ]; then
    echo -e "${YELLOW}⚠️  Cartella Migrations già esistente${NC}"
    read -p "Vuoi ricreare le migrations? (s/N): " RECREATE
    if [[ $RECREATE =~ ^[Ss]$ ]]; then
        echo "Rimuovo migrations esistenti..."
        rm -rf ../LeadOne2.Infrastructure/Migrations
        echo -e "${GREEN}✅ Migrations rimosse${NC}"
    fi
fi
echo ""

# Crea migration iniziale
echo "5. Creo migration iniziale..."
dotnet ef migrations add InitialCreate --project ../LeadOne2.Infrastructure --startup-project . --verbose

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Migration 'InitialCreate' creata con successo${NC}"
else
    echo -e "${RED}❌ Errore durante la creazione della migration${NC}"
    exit 1
fi
echo ""

# Applica migration al database
echo "6. Applico migration al database..."
echo -e "${YELLOW}⚠️  Questo creerà il database e le tabelle${NC}"
read -p "Continuare? (S/n): " APPLY
if [[ ! $APPLY =~ ^[Nn]$ ]]; then
    dotnet ef database update --verbose

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Database creato e aggiornato con successo${NC}"
    else
        echo -e "${RED}❌ Errore durante l'aggiornamento del database${NC}"
        exit 1
    fi
else
    echo "Operazione annullata"
    exit 0
fi
echo ""

# Torna alla directory root
cd ../..

echo "=========================================="
echo -e "${GREEN}✅ Setup Database Completato!${NC}"
echo "=========================================="
echo ""
echo "Prossimi passi:"
echo "1. Avvia il backend: cd src/LeadOne2.Api && dotnet run"
echo "2. Crea utente admin tramite Swagger: http://localhost:5000/swagger"
echo "3. Testa il frontend: cd src/LeadOne2.Web && npm run dev"
echo ""
echo "Script per creare l'admin disponibile in: scripts/create-admin.sh"
echo ""
