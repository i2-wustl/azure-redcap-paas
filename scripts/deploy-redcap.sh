#! /bin/bash
if [ -z "$1" ]
then
    echo "No environment target specified for the deployment"
    echo "Example: ./deploy-redcap.sh dev SomePassword123"
    exit
fi
if [ -z "$2" ]
then
    echo "No password provided, please specify an admin password for the deployment"
    echo "Example: ./deploy-redcap.sh dev SomePassword123"
    exit
fi

location="Central US"
template="./azuredeploy.json"
parameters="$3" #./azuredeploy.parameters.$1.json"
subscription="66fc3882-1a21-4787-9351-af5aa8eb3563"
group="i2-redcap-$1-rg"
adminPassword="$2"

if [ -z "$parameters" ]
then
    parameters="./azuredeploy.parameters.$1.json"
fi

loggedIn=$(az account show --query state)

if [[ $loggedIn != "\"Enabled\"" ]]
then
    az login -o none
fi
az account set --subscription "$subscription"
az group create --name $group --location "$location"
az configure --defaults group="$group"

echo "Logged in, Resource Group set to: $group"

#grab cert and store it in the key vault...
#upload pfx to value
#az keyvault secret set --vault-name KEY_VAULT_NAME --encoding base64 --description text/plain --name CERT_SECRET_NAME --file certificate.pfx


az deployment group create \
    --resource-group $group \
    --template-file $template \
    --parameters $parameters \
    --parameters envName="$1" \
    --parameters administratorLoginPassword="$adminPassword" \
    --name "$group-redcap"


# Map your prepared custom domain name to the web app.
# az webapp config hostname add --webapp-name $webappname --resource-group $resourceGroup \
# --hostname $fqdn