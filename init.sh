region="centralus"
template="azuredeploy.json"
#template="azuredeploy_with_SendGrid.json"
parameters="azuredeploy.parameters.json"
subscription="829087ae-007e-48b5-96d9-8287ad3d00d0"
group=$1

loggedIn=$(az account show --query state)

if [[ $loggedIn != "\"Enabled\"" ]]
then
    az login -o none
fi
az account set --subscription "$subscription"
az group create --name $group --location "Central US"
az configure --defaults group="$group"

echo "Logged in, Resource Group set to: $group"

az deployment group create --resource-group $group --template-file $template --parameters $parameters --name "RCDeployment"


