# I2 REDCap Azure Deployment Instructions

This repository contains the assets used to build the I2 REDCap Azure environments. The repository is forked from the original REDCap Azure Repo found here: https://github.com/microsoft/azure-redcap-paas 

We made several modifications to the original repository to handle our unique deployment scenario. More information about the changes made can be found in `changes.md`.

## How-To Deploy a REDCap Environment

There are a few initial steps that must be completed before deploying the main REDCap resources to Azure. In order to to secure the website we will need to provision an SSL Certificate and request a couple of DNS entries. We will also need an App Registration in Azure Active Directory to enable WUSTL Key authentication.

Through out this guide there will be placeholders included in the text. The two most common placeholders are: {env} and {hostname}. The placeholders should be replace with the appropriate value. For example, the dev deployment would use `dev` in place of {env} and `redcapdev.wustl.edu` in place of {hostname}. Other values for placeholders will be explained in the context they are used.

### Azure AD App Registration

Each deployment will need an App Registration to be created in Azure Active Directory if one does not already exist. If there is an existing registration, ensure that the correct redirect URI is assigned to the the application. An example of what the URI should be is shown below.

We need to file a Service Now ticket to request these entries. Follow these steps to submit the request:

1. Open https://wustl.service-now.com/sp?id=sc_home
1. Click General Service Request
1. Include this text in the description box.

```
I need to have an App Registration created in Azure AD to allow for Azure AD/WUSTLKey authentication for a new REDCap deployment. Below are the details for the registration:

App Name: i2-redcap-{env}
Platform: Web
Redirect URIs: 
    https://{hostname}/.auth/login/aad/callback
    https://{hostname}/redcap/.auth/login/aad/callback
Tokens: ID tokens enabled

```
4. Click order now

This ticket will eventually get routed to the Identity Management team for processing. I was told that you can email them directly after submitting the ticket to help speed the process up and ensure they have all of the information they need. The current contacts are: mulchekp@wustl.edu and paul.malawy@wustl.edu.

These registrations will be used during app service creation. So, they will need to be in place before proceeding with the main deployment step. However, we can continue with some additional configuration as described in the next section.

### vNet IP Provisioning

TODO: fill in info about getting IP allocation

### Pre-deployment configuration

We start by creating a resource group, static IP address, and certificate for the deployment. You can use the `scripts/pre-config.sh` script to create he resource group, IP address, and certificate. For example, to pre-configure QA you would issue this command:

`./scripts/pre-config.sh qa redcapqa.wustl.edu`

Once created, you will need to login the the Azure portal and link the new certificate to the REDCap key vault. You will also need to copy the domain verification information for the certificate. To do so, follow these steps:

1. Open https://portal.azure.com
2. Select the newly created resource group
3. Select the certificate you just created
4. Click `Certificate Configuration` from the menu on the left
5. Click `Step 1: Store`
6. Select `i2-redcap-keys` from the Key Vault list
7. Exit the Store configuration (X on the upper right)
8. Click `Step 2: Domain Verification`
9. Copy the `Domain Verification Token`
    * _NOTE:_ you will need this token when you create a Service Now ticket in the `Additional Details` form field discussed following section.

### DNS Entry Creation

Now that we have a certificate created, we can request the necessary DNS entries we need for domain verification. We need to have two `TXT` entries created for each REDCap environment/deployment. One entry will be used to verify ownership of the domain. This is necessary to complete the certificate creation process. The other will allow us to assign the domain to the app service once it is created.

We need to file a Service Now ticket to request these entries. Follow these steps to submit the request:

1. Open https://wustl.service-now.com/sp?id=sc_home
2. Search for `DNS` in the service catalog search box
3. Click `IP Address DHCP and DNS Management`
4. Fill out the form with the following information:
    * Date needed: {Select an appropriate date}
    * IP address of the device: See below
    * Domain name: {hostname}
    * Additional details: 
   ```
    Please create the following two DNS entries:
    
    @ - TXT - {domainVerificationToken}

    awverify.{hostname} - TXT - awverify.i2-redcap-{env}-web.azurewebsites.net
    
    Thank you!
    ```    
    _NOTE: Replace the {Placeholders} with the appropriate values. You may need to return to the Azure Portal to get the IP Address and/or verification token if you do not have them available._

5. Verify that the correct values are included in the additional details and click the `Order Now` button.


### Completing Certificate Setup

Once the DNS entries have been created, we can return to the Azure Portal and complete the Certificate setup. There are three tasks to complete the setup. First, the domain verification needs to be completed. Then the certification secret needs to be exported. Finally we import the secret into the Key Vault certificates. This final step allows the Application Gateway to use the certificate that has been issued for the hostname we specified during pre-configuration.

Follow these steps to finalize the domain verification.

1. Open https://portal.azure.com
1. Select the appropriate resource group
1. Select the certificate that was created previously
1. Click `Step 2: Domain Verification`
1. Click `Refresh` if necessary to complete the verification process

Now we need to export the certificate private key (aka secret) from the Key Vault.

1. Click `Export Certificate`
1. Click `Open Key Vault Secret`
1. Click on the `Current Version` of the secret
    * _NOTE:_ the current version should show an `Activation date` and an `Expiration date`
1. Scroll down and click the `Download as a certificate` button
1. Save the `pfx` file to a local folder

Finally import the `pfx` file into the Key Vault certificates.

1. Open the `Certificates` section of the [i2-redcap-keys Key Vault](https://portal.azure.com/#@gowustl.onmicrosoft.com/resource/subscriptions/66fc3882-1a21-4787-9351-af5aa8eb3563/resourceGroups/i2-redcap-main-rg/providers/Microsoft.KeyVault/vaults/i2-redcap-keys/certificates)
1. Click `Generate/Import`
1. Select `Import`
1. Certificate Name: `i2-redcap-{env}-gateway-cert`
1. Certificate File: select the `pfx` file you exported
1. Password: {leave blank}
1. Click `Create`


### Deploy Main Template and Configure app

Now that all of the necessary configuration is done, we can deploy the main REDCap resources. To do this all we will need to is run the deployment script with a few  parameters. The parameters are the {env} and the password to use for admin access to the database.

```
./scripts/deploy-redcap.sh {env} {adminPassword}
```
This script will take several minutes to run. Once it is complete you will be able to browse to the new REDCap deployment using the default URL provided by the app service. It should look like this: https://i2-redcap-{env}-web.azurewebsites.net/index.php

#### Manual App Configuration

After the application is created we need to do a few manual configuration steps. We will need to add the custom domain to the app service, configure the SSL binding, and enable WUSTL Key authentication. All of these steps can be completed using the [Azure Portal](https://portal.azure.com).

##### Add Domain and SSL Binding

1. Open the newly created app service
1. Open the `Custom Domains` view
1. Click `Add custom domain`
1. Enter {hostname}
1. Click `Validate`
1. Click `Add custom domain`
1. Click `Add binding` under the SSL Binding heading for teh domain you just added
1. Click `Import App Service Certificate`
1. Select the certificate we created for this deployment ie `i2-redcap-{env}-cert
1. Click `Ok`
1. Select the `Private Certificate Thumbprint` for the domain
1. Select the certificate and specify `SNI SSL`
1. Click `Adding Binding`


**References**
[Configure Custom Domain](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-tutorial-custom-domain?tabs=cname)
[Configure SSL](https://docs.microsoft.com/en-us/azure/app-service/configure-ssl-bindings)


##### Configure Authentication

1. Open the `Authentication` view for the app service.
1. Click `Add Identity Provider`
1. Select Microsoft for Identity Provider drop down
1. App registration type: `Provide the details of an existing app registration`
1. Application Id: <Provided By WUIT>
1. Client Secret: <Provided By WUIT>
1. Authentication: `Allow unauthenticated access`
1. Click `Add`


**References**
[Configure AAD Authentication](https://docs.microsoft.com/en-us/azure/app-service/configure-authentication-provider-aad#configure-client-apps-to-access-your-app-service)


### Landing Page Settings

Once you are able to configure REDCap and issue an API Token, you will need to update the `VersionApiToken` setting for the AppService. This setting is used by the `landing.php` page to pull the current version of REDCap.

### Domain DNS Entry

We need to file a Service Now ticket to request a standard `A` record that will point the hostname to the IP Address of the gateway. I recommend submitting the request as soon as you have completed setting up the app service. This allows the request to be processed while you finalize the deployment.

Follow these steps to submit the request:

1. Open https://wustl.service-now.com/sp?id=sc_home
2. Search for `DNS` in the service catalog search box
3. Click `IP Address DHCP and DNS Management`
4. Fill out the form with the following information:
    * Date needed: {Select an appropriate date}
    * IP address of the device: See below
    * Domain name: {hostname}
    * Additional details: 
   ```
    Please create the following two DNS entries:
    
    {hostname} - A - {ipAddress}
    
    Thank you!
    ```    
    _NOTE: Replace the {Placeholders} with the appropriate values. You may need to return to the Azure Portal to get the IP Address and/or verification token if you do not have them available._

5. Verify that the correct values are included in the additional details and click the `Order Now` button.

### SMTP Relay Allow List

To enable the app service to send email, we need to request that the outbound IP address of the app service be added to the allow list for the `rsmtp.wustl.edu` mail server.

TODO: Add instructions on how to request smtp allow list entires

### Deploy Gateway Template

The final step is to deploy the Application Gateway. To do this run the following script and provide the {env} and optionally a certificate name. Assuming you used the `pre-config.sh` script the certificate name should be `i2-redcap-{env}-cert`. If no certificate name is provided to the script it will default to that naming pattern.

 `./scripts/deploy-gateway.sh {env} {certificateName}`

This script will also take a few minutes to complete. Once the script finishes you should be able to browse to https://{hostname} and log into the new REDCap deployment.


### Final Cleanup

Once the deployment is complete we should request that the verification entires be deleted from DNS. 

Here are the steps to do so:

1. Open https://wustl.service-now.com/sp?id=sc_home
2. Search for `DNS` in the service catalog search box
3. Click `IP Address DHCP and DNS Management`
4. Fill out the form with the following information:
    * Date needed: {Select an appropriate date}
    * IP address of the device: See below
    * Domain name: {hostname}
    * Additional details: 
   ```
    Please delete the following two DNS entries:
    
    @ - TXT - {domainVerificationToken}

    awverify.{hostname} - TXT - awverify.i2-redcap-{env}-web.azurewebsites.net
    
    Thank you!
    ```    
    _NOTE: Replace the {Placeholders} with the appropriate values. You may need to return to the Azure Portal to get the IP Address and/or verification token if you do not have them available._

5. Verify that the correct values are included in the additional details and click the `Order Now` button.
