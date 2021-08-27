location="Central US"
template="../gateway/certificate.json"
# parameters="azuredeploy.parameters.json"
subscription="66fc3882-1a21-4787-9351-af5aa8eb3563"
#siteName="i2-redcap-$1"
group="i2-redcap-$1-rg" #i2redcap2-dev-rg-main
#adminPassword="$2"
distinguishedName="CN=$2"

if [ -z "$1" ]
then
    echo "No environment target specified for the deployment"
    echo "Example: ./init dev redcapdev.wustl.edu"
    exit
fi

if [ -z "$2" ]
then
    echo "No hostname specified for the deployment"
    echo "Example: ./init dev redcapdev.wustl.edu"
    exit
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
echo "Creating initial assets for $1 - $distinguishedName"

az deployment group create \
    --resource-group $group \
    --template-file $template \
    --name "$group-pre-configure" \
    --parameters ipAddressName="i2-redcap-$1-ip" \
    --parameters certificateOrderName="i2-redcap-$1-cert" \
    --parameters distinguishedName="$distinguishedName" \
    --parameters autoRenew="true" 
