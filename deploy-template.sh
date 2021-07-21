region="centralus"
template=$2 #"azuredeploy.json"
#template="azuredeploy_with_SendGrid.json"
parameters=$3 #"azuredeploy.parameters.json"
#subscription="829087ae-007e-48b5-96d9-8287ad3d00d0" #I2 - Sandbox
subscription="66fc3882-1a21-4787-9351-af5aa8eb3563" #ICS - Redcap
group="$1-rg" # "$1-rg" #i2redcap2-dev-rg-main

loggedIn=$(az account show --query state)

if [[ $loggedIn != "\"Enabled\"" ]]
then
    az login -o none
fi
az account set --subscription "$subscription"
az group create --name $group --location "Central US"
az configure --defaults group="$group"

echo "Logged in, Resource Group set to: $group"


az deployment group create \
    --resource-group $group \
    --template-file $template \
    --parameters $parameters  \
    --name "$1-deployment" # \
    #--parameters siteName="$1"


