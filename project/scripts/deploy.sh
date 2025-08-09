#!/bin/bash

# Deploy Script for AI Document Assistant on EKS
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Deploying AI Document Assistant to EKS${NC}"

# Check if kubectl is configured
if ! kubectl cluster-info &> /dev/null; then
    echo -e "${RED}❌ kubectl is not configured or cluster is not accessible.${NC}"
    echo -e "${YELLOW}Run setup-eks.sh first or configure kubectl manually.${NC}"
    exit 1
fi

echo -e "${YELLOW}📝 Step 1: Creating namespace...${NC}"
kubectl apply -f k8s/namespace.yaml

echo -e "${YELLOW}📝 Step 2: Deploying PostgreSQL database...${NC}"
kubectl apply -f k8s/database.yaml

echo -e "${YELLOW}📝 Step 3: Waiting for database to be ready...${NC}"
kubectl wait --for=condition=available --timeout=300s deployment/postgres -n ai-document-assistant

echo -e "${YELLOW}📝 Step 4: Deploying backend service...${NC}"
kubectl apply -f k8s/backend.yaml

echo -e "${YELLOW}📝 Step 5: Waiting for backend to be ready...${NC}"
kubectl wait --for=condition=available --timeout=300s deployment/ai-document-backend -n ai-document-assistant

echo -e "${YELLOW}📝 Step 6: Deploying frontend service...${NC}"
kubectl apply -f k8s/frontend.yaml

echo -e "${YELLOW}📝 Step 7: Waiting for frontend to be ready...${NC}"
kubectl wait --for=condition=available --timeout=300s deployment/ai-document-frontend -n ai-document-assistant

echo -e "${GREEN}✅ Deployment completed successfully!${NC}"

echo -e "${YELLOW}📝 Getting service information...${NC}"
kubectl get services -n ai-document-assistant

echo -e "${YELLOW}📝 Getting pod status...${NC}"
kubectl get pods -n ai-document-assistant

echo -e "${YELLOW}📝 Getting LoadBalancer URL...${NC}"
echo "Waiting for LoadBalancer to get external IP..."
kubectl get service ai-document-frontend-service -n ai-document-assistant --watch

echo -e "${GREEN}🎉 Application deployed successfully!${NC}"
echo -e "${GREEN}Access your application using the EXTERNAL-IP from the LoadBalancer service.${NC}" 