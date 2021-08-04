#  id=$(az webapp config ssl list --resource-group i2-redcap-dev-rg --query "[?contains(@.name, 'i2-redcap-dev')].{id:name}[0].id")
#  echo "ID: $id"
#  az webapp config ssl show --resource-group i2-redcap-dev-rg --certificate-name "i2-redcap-dev-cert"



# #  certId=$(az keyvault secret list --vault-name i2-redcap-keys \
# #     --query "[?name > 'i2-redcap-dev'].{id: id, name: name,tags: tags}[?tags.CertificateState == 'Ready'].{id:name}[0].id")


# az webapp config ssl list --resource-group i2-redcap-dev-rg --query "[?contains(@.name, 'i2-redcap-dev')]"


# #https://docs.microsoft.com/en-us/azure/app-service/scripts/cli-configure-ssl-certificate

#az keyvault certificate show --name "i2-redcap-dev-gateway-cert" --vault-name "i2-redcap-keys" --query "sid" -o tsv



az webapp config hostname add \
    --webapp-name i2-redcap-qa-web \
    --resource-group i2-redcap-qa-rg \
    --hostname redcapqa.wustl.edu \
    --verbose