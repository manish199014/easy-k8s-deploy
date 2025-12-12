#!/usr/bin/env bash
set -eo pipefail

echo "========================================="
echo "AKS Cluster Deployment Script"
echo "========================================="

# Step 1: Install Terraform using tfenv
echo ""
echo "Step 1: Installing Terraform 1.7.0..."
if [ ! -d "$HOME/.tfenv" ]; then
    git clone https://github.com/tfutils/tfenv.git ~/.tfenv
    mkdir -p ~/bin
    ln -s ~/.tfenv/bin/* ~/bin/ 2>/dev/null || true
    export PATH=$PATH:~/bin/
fi
tfenv install 1.7.0 || true
tfenv use 1.7.0

# Step 2: Authenticate to Azure using Service Principal
echo ""
echo "Step 2: Authenticating to Azure..."
az login --service-principal \
    --username "$AZURE_CLIENT_ID" \
    --password "$AZURE_CLIENT_SECRET" \
    --tenant "$AZURE_TENANT_ID" > /dev/null

# Step 3: Auto-detect Subscription ID
echo ""
echo "Step 3: Auto-detecting Azure Subscription..."
export AZURE_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
echo "Detected Subscription ID: $AZURE_SUBSCRIPTION_ID"

# Step 4: Auto-detect Resource Group
echo ""
echo "Step 4: Auto-detecting Resource Group..."
export AZURE_RESOURCE_GROUP=$(az group list --query "[0].name" -o tsv)
echo "Detected Resource Group: $AZURE_RESOURCE_GROUP"

# Step 5: Get location from the Resource Group
export AZURE_LOCATION=$(az group show --name "$AZURE_RESOURCE_GROUP" --query location -o tsv)
echo "Detected Location: $AZURE_LOCATION"

# Step 6: Export credentials for Terraform
export AZURE_TENANT_ID="$AZURE_TENANT_ID"
export AZURE_CLIENT_ID="$AZURE_CLIENT_ID"
export AZURE_CLIENT_SECRET="$AZURE_CLIENT_SECRET"

# Step 7: Run Terraform
echo ""
echo "Step 5: Deploying AKS cluster using Terraform..."
cd terraform/

terraform init
echo ""
terraform plan
echo ""
terraform apply -auto-approve

# Step 8: Configure kubectl
echo ""
echo "Step 6: Configuring kubectl access..."
CLUSTER_NAME=$(terraform output -raw cluster_name)
RESOURCE_GROUP=$(terraform output -raw resource_group_name)

az aks get-credentials \
    --resource-group "$RESOURCE_GROUP" \
    --name "$CLUSTER_NAME" \
    --overwrite-existing

# Step 9: Verify cluster
echo ""
echo "Step 7: Verifying cluster..."
kubectl get nodes

echo ""
echo "========================================="
echo "AKS Cluster Deployment Complete!"
echo "========================================="
echo ""
echo "Cluster Name: $CLUSTER_NAME"
echo "Resource Group: $RESOURCE_GROUP"
echo "Location: $AZURE_LOCATION"
echo ""
echo "You can now use kubectl to interact with your cluster."
