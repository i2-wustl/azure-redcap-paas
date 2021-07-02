region="centralus"
template="azuredeploy.json"
#template="azuredeploy_with_SendGrid.json"
parameters="azuredeploy.parameters.json"
subscription="66fc3882-1a21-4787-9351-af5aa8eb3563"
group="$1-rg" #i2redcap2-dev-rg-main

loggedIn=$(az account show --query state)

if [[ $loggedIn != "\"Enabled\"" ]]
then
    az login -o none
fi
az account set --subscription "$subscription"
az group create --name $group --location "Central US"
az configure --defaults group="$group"

echo "Logged in, Resource Group set to: $group"

az deployment group create --resource-group $group --template-file $template --parameters $parameters --parameters siteName="$1" --name "RCDeploymentTest01"


