#!/bin/bash
# Local CI/CD script to run all checks before pushing
# Usage: ./scripts/ci.sh

set -e

echo "Starting Local CI/CD Pipeline..."
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Install dependencies
echo -e "${YELLOW}Installing dependencies...${NC}"
npm ci
echo -e "${GREEN}Dependencies installed${NC}\n"

# Step 2: Lint
echo -e "${YELLOW}Running ESLint...${NC}"
npm run lint
echo -e "${GREEN}ESLint passed${NC}\n"

# Step 3: Type check
echo -e "${YELLOW}Running TypeScript check...${NC}"
npx tsc --noEmit
echo -e "${GREEN}TypeScript check passed${NC}\n"

# Step 4: Build
echo -e "${YELLOW}Building project...${NC}"
npm run build
echo -e "${GREEN}Build successful${NC}\n"

echo -e "${GREEN}All checks passed! Ready to push!${NC}"
