# Overview of changes made to original repo

--Is this section worth keeping?

- Files/settings.ini: Added configuration for large uploads
- azuredeploy.json
    - Updated $schema references to new versions
    - Added additional SKUs to be used as parameters. This allows P2V2 support.
    - Updated various apiVersion values
    - Add httpsOnly configuration
    - Fixed some schema validation issues due to version upgrades
    - Normalizing resource names
- azuredeploy.parameters.json
    - Added default values
    - NOTE: the admin password in the template is overwritten by the init script which requires you pass in the admin password as a parameter.    
- init.sh
    - Added this script to automate the CLI steps to deploy the template. This could certainly be improved but does make it easier to test changes to the template/deployment
