#!/bin/bash
# Script di test API per LeadOne2 usando cURL
# Eseguire con backend attivo su http://localhost:5000

BASE_URL="http://localhost:5000/api"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================="
echo "   LeadOne2 - API Test Script"
echo "==========================================${NC}"
echo ""

# Verifica che il backend sia in esecuzione
echo -e "${YELLOW}Verifico che il backend sia in esecuzione...${NC}"
if ! curl -s -f -o /dev/null "$BASE_URL/../swagger/index.html"; then
    echo -e "${RED}❌ Backend non raggiungibile su http://localhost:5000${NC}"
    echo "Avvia il backend prima di eseguire i test:"
    echo "  cd src/LeadOne2.Api && dotnet run"
    exit 1
fi
echo -e "${GREEN}✅ Backend raggiungibile${NC}"
echo ""

# Test 1: Registrazione
echo -e "${BLUE}=========================================="
echo "Test 1: Registrazione nuovo utente"
echo "==========================================${NC}"

REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@leadone.it",
    "password": "Test123!",
    "name": "Test",
    "surname": "User"
  }')

echo "$REGISTER_RESPONSE" | jq '.' 2>/dev/null || echo "$REGISTER_RESPONSE"

# Estrai token dalla response
TOKEN=$(echo "$REGISTER_RESPONSE" | jq -r '.token' 2>/dev/null)

if [ "$TOKEN" != "null" ] && [ -n "$TOKEN" ]; then
    echo -e "${GREEN}✅ Registrazione completata${NC}"
    echo -e "Token: ${YELLOW}${TOKEN:0:50}...${NC}"
else
    echo -e "${YELLOW}⚠️  Utente potrebbe già esistere. Provo con login...${NC}"

    # Prova login
    LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
      -H "Content-Type: application/json" \
      -d '{
        "email": "test@leadone.it",
        "password": "Test123!"
      }')

    TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.token' 2>/dev/null)

    if [ "$TOKEN" != "null" ] && [ -n "$TOKEN" ]; then
        echo -e "${GREEN}✅ Login completato${NC}"
        echo -e "Token: ${YELLOW}${TOKEN:0:50}...${NC}"
    else
        echo -e "${RED}❌ Impossibile ottenere il token${NC}"
        echo "Response: $LOGIN_RESPONSE"
        exit 1
    fi
fi

sleep 1
echo ""

# Test 2: Verifica utente corrente
echo -e "${BLUE}=========================================="
echo "Test 2: Verifica utente corrente"
echo "==========================================${NC}"

ME_RESPONSE=$(curl -s -X GET "$BASE_URL/auth/me" \
  -H "Authorization: Bearer $TOKEN")

echo "$ME_RESPONSE" | jq '.' 2>/dev/null || echo "$ME_RESPONSE"

if echo "$ME_RESPONSE" | jq -e '.id' > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Utente verificato${NC}"
    USER_ID=$(echo "$ME_RESPONSE" | jq -r '.id')
    IS_ADMIN=$(echo "$ME_RESPONSE" | jq -r '.isAdmin')
    echo -e "User ID: ${YELLOW}$USER_ID${NC}"
    echo -e "Is Admin: ${YELLOW}$IS_ADMIN${NC}"
else
    echo -e "${RED}❌ Errore nella verifica utente${NC}"
fi

sleep 1
echo ""

# Test 3: Lista progetti
echo -e "${BLUE}=========================================="
echo "Test 3: Lista tutti i progetti"
echo "==========================================${NC}"

PROJECTS_RESPONSE=$(curl -s -X GET "$BASE_URL/projects" \
  -H "Authorization: Bearer $TOKEN")

echo "$PROJECTS_RESPONSE" | jq '.' 2>/dev/null || echo "$PROJECTS_RESPONSE"

PROJECT_COUNT=$(echo "$PROJECTS_RESPONSE" | jq 'length' 2>/dev/null || echo "0")
echo -e "${GREEN}✅ Progetti trovati: $PROJECT_COUNT${NC}"

sleep 1
echo ""

# Test 4: Crea progetto (solo se admin)
echo -e "${BLUE}=========================================="
echo "Test 4: Crea nuovo progetto (richiede Admin)"
echo "==========================================${NC}"

if [ "$IS_ADMIN" = "true" ]; then
    CREATE_PROJECT_RESPONSE=$(curl -s -X POST "$BASE_URL/projects" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d '{
        "name": "Progetto Test da Script",
        "description": "Creato automaticamente dal test script"
      }')

    echo "$CREATE_PROJECT_RESPONSE" | jq '.' 2>/dev/null || echo "$CREATE_PROJECT_RESPONSE"

    if echo "$CREATE_PROJECT_RESPONSE" | jq -e '.id' > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Progetto creato con successo${NC}"
        PROJECT_ID=$(echo "$CREATE_PROJECT_RESPONSE" | jq -r '.id')
        echo -e "Project ID: ${YELLOW}$PROJECT_ID${NC}"
    else
        echo -e "${RED}❌ Errore nella creazione del progetto${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Utente non è Admin, skip creazione progetto${NC}"
    echo "Per testare la creazione progetti:"
    echo "  1. Connettiti al database"
    echo "  2. Esegui: UPDATE Users SET IsAdmin = 1 WHERE Email = 'test@leadone.it'"
    echo "  3. Rilancia questo script"
fi

sleep 1
echo ""

# Test 5: I miei progetti
echo -e "${BLUE}=========================================="
echo "Test 5: I miei progetti"
echo "==========================================${NC}"

MY_PROJECTS_RESPONSE=$(curl -s -X GET "$BASE_URL/projects/my-projects" \
  -H "Authorization: Bearer $TOKEN")

echo "$MY_PROJECTS_RESPONSE" | jq '.' 2>/dev/null || echo "$MY_PROJECTS_RESPONSE"

MY_PROJECT_COUNT=$(echo "$MY_PROJECTS_RESPONSE" | jq 'length' 2>/dev/null || echo "0")
echo -e "${GREEN}✅ Miei progetti: $MY_PROJECT_COUNT${NC}"

sleep 1
echo ""

# Riepilogo
echo -e "${BLUE}=========================================="
echo "Riepilogo Test"
echo "==========================================${NC}"
echo -e "${GREEN}✅ Test completati${NC}"
echo ""
echo "Token salvato in: /tmp/leadone2_token.txt"
echo "$TOKEN" > /tmp/leadone2_token.txt
echo ""
echo "Per usare il token in altri test:"
echo -e "  ${YELLOW}export TOKEN=\$(cat /tmp/leadone2_token.txt)${NC}"
echo -e "  ${YELLOW}curl -H \"Authorization: Bearer \$TOKEN\" $BASE_URL/projects${NC}"
echo ""
echo "Oppure apri Swagger e usa il token:"
echo "  http://localhost:5000/swagger"
echo ""
