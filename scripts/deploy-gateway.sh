region="centralus"
template="../gateway/gateway-template.json"
#template="azuredeploy_with_SendGrid.json"
parameters="../gateway/gateway-template.parameters.json"
#subscription="829087ae-007e-48b5-96d9-8287ad3d00d0" #I2 - Sandbox
subscription="66fc3882-1a21-4787-9351-af5aa8eb3563" #ICS - Redcap
group="i2-redcap-$1-rg" # "$1-rg" #i2redcap2-dev-rg-main
certName=$2

if [ -z "$1" ]
then
    echo "No environment target specified for the deployment";
    echo "Example: ./deploy-gateway.sh dev";
    exit;
fi

if [ -z "$2" ]
then
    certName="i2-redcap-$1-gateway-cert"
fi

echo "Logging in and configuring script environment..."
loggedIn=$(az account show --query state)

if [[ $loggedIn != "\"Enabled\"" ]]
then
    az login -o none
fi
az account set --subscription "$subscription" -o none
az group create --name $group --location "Central US" -o none
az configure --defaults group="$group" 

echo "Logged in, Resource Group set to: $group"

# certId=$(az keyvault secret list --vault-name i2-redcap-keys \
#     --query "[?name > 'i2-redcap-dev'].{id: id, name: name,tags: tags}[?tags.CertificateState == 'Ready'].{id:name}[0].id")

#certId=$(az keyvault certificate show --name $certName --vault-name i2-redcap-keys --query "sid")
certId=$(az keyvault certificate show --name "$certName" --vault-name "i2-redcap-keys" --query "sid" -o tsv)
if [ -z "$certId" ]
then
    echo "No secret found for $certName";
    echo "Please ensure you have imported the certificate into the keyvault."
    echo "See the Completing Certificate Setup section the deployment guide for more information."
    exit;
fi

echo "Found certificate $certName: $certId"
echo "Deploying gateway template, this could take a minute..."

#certId="https://i2-redcap-keys.vault.azure.net/secrets/i2-redcap-dev-gateway-cert/d2f48c9d30964e68b160432f4bb59f9c"
az deployment group create \
    --resource-group $group \
    --template-file $template \
    --parameters $parameters  \
    --name "$group-gateway-deployment" \
    --parameters envName="$1" \
    --parameters certSecretId="$certId"

echo "Gateway template has been deployed to $group"