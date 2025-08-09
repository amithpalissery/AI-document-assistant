# 🚀 AWS EKS Deployment Guide for AI Document Assistant

This guide will walk you through deploying the AI Document Assistant to AWS EKS with a beautiful, production-ready setup.

## 📋 Prerequisites

### Required Tools
- **AWS CLI** (configured with proper credentials)
- **Docker** (running)
- **eksctl** (for EKS cluster management)
- **kubectl** (for Kubernetes management)

### AWS Setup
- AWS Account with appropriate permissions
- ECR repositories access
- EKS service access
- VPC and networking configured

## 🛠️ Installation Commands

### 1. Install AWS CLI
```bash
# Windows (PowerShell)
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

# Mac
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install
```

### 2. Install eksctl
```bash
# Windows (PowerShell)
choco install eksctl

# Mac
brew tap weaveworks/tap && brew install weaveworks/tap/eksctl

# Linux
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
```

### 3. Install kubectl
```bash
# Windows (PowerShell)
choco install kubernetes-cli

# Mac
brew install kubectl

# Linux
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

## 🔧 Configuration

### 1. Configure AWS CLI
```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter your preferred region (e.g., us-west-2)
# Enter output format (json)
```

### 2. Update Deployment Variables
Edit these files with your AWS details:

**`scripts/build-and-push.sh`:**
```bash
AWS_REGION="your-preferred-region"
AWS_ACCOUNT_ID="your-aws-account-id"
```

**`scripts/setup-eks.sh`:**
```bash
AWS_REGION="your-preferred-region"
CLUSTER_NAME="your-cluster-name"
```

## 🚀 Deployment Steps

### Step 1: Set Up EKS Cluster
```bash
chmod +x scripts/setup-eks.sh
./scripts/setup-eks.sh
```
⏱️ **Time:** ~15-20 minutes

**What this does:**
- Creates an EKS cluster with managed node group
- Configures kubectl to connect to your cluster
- Sets up necessary networking and security groups

### Step 2: Build and Push Docker Images
```bash
chmod +x scripts/build-and-push.sh
./scripts/build-and-push.sh
```
⏱️ **Time:** ~5-10 minutes

**What this does:**
- Builds Docker images for frontend and backend
- Creates ECR repositories
- Pushes images to ECR
- Updates Kubernetes manifests with correct image URIs

### Step 3: Deploy Application
```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```
⏱️ **Time:** ~5-10 minutes

**What this does:**
- Creates Kubernetes namespace
- Deploys PostgreSQL database with persistent storage
- Deploys backend service (FastAPI)
- Deploys frontend service (React)
- Creates LoadBalancer for external access

## 🌐 Accessing Your Application

After deployment, get your application URL:

```bash
kubectl get service ai-document-frontend-service -n ai-document-assistant
```

Look for the `EXTERNAL-IP` column - this is your public URL!

## 📊 Monitoring and Management

### Check Pod Status
```bash
kubectl get pods -n ai-document-assistant
```

### Check Services
```bash
kubectl get services -n ai-document-assistant
```

### View Logs
```bash
# Backend logs
kubectl logs -f deployment/ai-document-backend -n ai-document-assistant

# Frontend logs
kubectl logs -f deployment/ai-document-frontend -n ai-document-assistant

# Database logs
kubectl logs -f deployment/postgres -n ai-document-assistant
```

### Scale Application
```bash
# Scale backend
kubectl scale deployment ai-document-backend --replicas=3 -n ai-document-assistant

# Scale frontend
kubectl scale deployment ai-document-frontend --replicas=3 -n ai-document-assistant
```

## 🏗️ Architecture Overview

```
Internet
    ↓
AWS LoadBalancer (ELB)
    ↓
Frontend Service (React + Nginx)
    ↓
Backend Service (FastAPI)
    ↓
PostgreSQL Database (Persistent Storage)
```

**Components:**
- **Frontend**: React app with beautiful UI, served by Nginx
- **Backend**: FastAPI with Pydantic validation and CORS
- **Database**: PostgreSQL with persistent volumes
- **LoadBalancer**: AWS ELB for external access
- **Storage**: EBS volumes for database persistence

## 💰 Cost Estimation

**Monthly costs (approximate):**
- EKS Cluster: $73/month
- EC2 Instances (t3.medium × 2): ~$60/month
- EBS Storage (5GB): ~$0.50/month
- LoadBalancer: ~$18/month
- **Total: ~$150/month**

## 🔒 Security Features

- **Network isolation** with VPC and security groups
- **RBAC** (Role-Based Access Control) for Kubernetes
- **Secrets management** for database credentials
- **Image scanning** with ECR
- **Resource limits** and quotas

## 🧹 Cleanup

To avoid ongoing charges, clean up resources:

```bash
# Delete Kubernetes resources
kubectl delete namespace ai-document-assistant

# Delete EKS cluster
eksctl delete cluster --name ai-document-assistant-cluster --region us-west-2

# Delete ECR repositories (optional)
aws ecr delete-repository --repository-name ai-document-assistant-backend --force
aws ecr delete-repository --repository-name ai-document-assistant-frontend --force
```

## 🐛 Troubleshooting

### Common Issues

**1. kubectl not working:**
```bash
aws eks update-kubeconfig --region your-region --name your-cluster-name
```

**2. Images not pulling:**
- Check ECR repository permissions
- Verify image URIs in manifests
- Check node group IAM roles

**3. LoadBalancer pending:**
- Check AWS Load Balancer Controller
- Verify VPC and subnet configurations
- Check security group rules

**4. Database connection issues:**
- Check if PostgreSQL pod is running
- Verify service discovery (DNS)
- Check environment variables

### Useful Commands

```bash
# Get detailed pod information
kubectl describe pod <pod-name> -n ai-document-assistant

# Get events
kubectl get events -n ai-document-assistant --sort-by='.lastTimestamp'

# Execute into a pod
kubectl exec -it <pod-name> -n ai-document-assistant -- /bin/bash

# Port forward for local testing
kubectl port-forward service/ai-document-backend-service 8080:80 -n ai-document-assistant
```

## 🎉 Success!

Your AI Document Assistant is now running on AWS EKS with:
- ✅ Beautiful, responsive UI
- ✅ Scalable microservices architecture
- ✅ Persistent data storage
- ✅ Production-ready deployment
- ✅ Public internet access

Visit your LoadBalancer URL and enjoy your production AI application! 🚀 