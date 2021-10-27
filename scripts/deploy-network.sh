#! /bin/bash
if [ -z "$1" ]
then
    echo "No environment target specified for the deployment"
    echo "Example: ./deploy-network.sh dev"
    exit
fi

location="Central US"
template="./gateway/network-template.json"
parameters="./gateway/network-template.parameters.$1.json"
subscription="66fc3882-1a21-4787-9351-af5aa8eb3563"
group="i2-redcap-$1-rg"

loggedIn=$(az account show --query state)

if [[ $loggedIn != "\"Enabled\"" ]]
then
    az login -o none
fi
az account set --subscription "$subscription"
az group create --name $group --location "$location"
az configure --defaults group="$group"

echo "Logged in, Resource Group set to: $group"
echo "Creating certificate and network assets for $1"

az deployment group create \
    --resource-group $group \
    --template-file $template \
    --parameters "$parameters" \
    --name "$group-network"