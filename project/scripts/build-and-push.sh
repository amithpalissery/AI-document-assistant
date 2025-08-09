#!/bin/bash

# Build and Push Script for AI Document Assistant
set -e

# Variables (Update these with your AWS details)
AWS_REGION="us-west-2"
AWS_ACCOUNT_ID="YOUR_ACCOUNT_ID"
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
PROJECT_NAME="ai-document-assistant"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Building and Pushing AI Document Assistant to AWS ECR${NC}"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker is not running. Please start Docker first.${NC}"
    exit 1
fi

echo -e "${YELLOW}📝 Step 1: Authenticating with AWS ECR...${NC}"
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY

echo -e "${YELLOW}📝 Step 2: Creating ECR repositories if they don't exist...${NC}"
aws ecr describe-repositories --repository-names ${PROJECT_NAME}-backend --region $AWS_REGION 2>/dev/null || \
aws ecr create-repository --repository-name ${PROJECT_NAME}-backend --region $AWS_REGION

aws ecr describe-repositories --repository-names ${PROJECT_NAME}-frontend --region $AWS_REGION 2>/dev/null || \
aws ecr create-repository --repository-name ${PROJECT_NAME}-frontend --region $AWS_REGION

echo -e "${YELLOW}📝 Step 3: Building Docker images...${NC}"
echo "Building backend image..."
docker build -t ${PROJECT_NAME}-backend ./backend

echo "Building frontend image..."
docker build -t ${PROJECT_NAME}-frontend ./frontend

echo -e "${YELLOW}📝 Step 4: Tagging images for ECR...${NC}"
docker tag ${PROJECT_NAME}-backend:latest $ECR_REGISTRY/${PROJECT_NAME}-backend:latest
docker tag ${PROJECT_NAME}-frontend:latest $ECR_REGISTRY/${PROJECT_NAME}-frontend:latest

echo -e "${YELLOW}📝 Step 5: Pushing images to ECR...${NC}"
docker push $ECR_REGISTRY/${PROJECT_NAME}-backend:latest
docker push $ECR_REGISTRY/${PROJECT_NAME}-frontend:latest

echo -e "${GREEN}✅ Successfully pushed images to ECR!${NC}"
echo -e "${GREEN}Backend Image: $ECR_REGISTRY/${PROJECT_NAME}-backend:latest${NC}"
echo -e "${GREEN}Frontend Image: $ECR_REGISTRY/${PROJECT_NAME}-frontend:latest${NC}"

# Update Kubernetes manifests with ECR URIs
echo -e "${YELLOW}📝 Step 6: Updating Kubernetes manifests...${NC}"
sed -i.bak "s|YOUR_ECR_URI|$ECR_REGISTRY|g" k8s/backend.yaml
sed -i.bak "s|YOUR_ECR_URI|$ECR_REGISTRY|g" k8s/frontend.yaml

echo -e "${GREEN}✅ Kubernetes manifests updated with ECR URIs!${NC}"
echo -e "${GREEN}🎉 Build and push completed successfully!${NC}" 