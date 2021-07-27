region="centralus"
template="azuredeploy.json"
parameters="azuredeploy.parameters.json"
subscription="66fc3882-1a21-4787-9351-af5aa8eb3563"
group="$1-rg" #i2redcap2-dev-rg-main
adminPassword="$2"
#adminPassword="devPassword!"
if [ -z "$1" ]
then
    echo "No environment target specified for the deployment";
    echo "Example: ./init dev SomePassword123";
    exit;
fi

if [ -z "$adminPassword" ]
then
    echo "No password provided, please specify an admin password for the deployment";
    echo "Example: ./init dev SomePassword123";
    exit;
fi

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
    --parameters $parameters \
    --parameters siteName="$1" \
    --parameters administratorLoginPassword="$adminPassword"
    --name "$1-deployment"


