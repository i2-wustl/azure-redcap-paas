# Overview of changes made

- Files/settings.ini: Added configuration for large uploads
- azuredeploy.json
    - Updated $schema references to new versions
    - Added additional SKUs to be used as parameters. This allows P2V2 support.
    - Updated various apiVersion values
    - Add httpsOnly configuration
    - Fixed some schema validation issues due to version upgrades
    - Normalizing resource names
- azuredeploy.parameters.json
    - Added POC default values
    - NOTE: the admin password is currently in this file. THIS IS A BAD IDEA! This should be removed and prevented from being commited to the repo if possible. It is left here for now to make it easy to test the template.
- init.sh
    - Added this script to automate the CLI steps to deploy the template. This could certainly be improved but does make it easier to test changes to the template/deployment


## Additional Steps
- landing page
- auth settings
    - allow unauth
    - aad
