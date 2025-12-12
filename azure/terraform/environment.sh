#!/usr/bin/env bash
set -eo pipefail

# Read environment variables set by start.sh
subscription_id="${AZURE_SUBSCRIPTION_ID}"
resource_group_name="${AZURE_RESOURCE_GROUP}"
location="${AZURE_LOCATION}"
tenant_id="${AZURE_TENANT_ID}"
client_id="${AZURE_CLIENT_ID}"
client_secret="${AZURE_CLIENT_SECRET}"

# Output JSON for Terraform external data source
cat <<EOF
{
    "subscription_id": "$subscription_id",
    "resource_group_name": "$resource_group_name",
    "location": "$location",
    "tenant_id": "$tenant_id",
    "client_id": "$client_id",
    "client_secret": "$client_secret"
}
EOF
