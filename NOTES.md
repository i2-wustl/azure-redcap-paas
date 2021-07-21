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
    - Deployed in the root of the current version of RC (could consider hosting a static site to decouple the landing page)
    - Contains links to current, v7 prod and v7 demo

- auth settings
    - allow unauth
    - aad





### DNS 
    - redcapdev.wustl.edu A 20.98.177.239
        - points to the dev application gateway
    - redcapqa.wustl.edu A 20.98.170.82
        - points to the qa application gateway
    - redcap.wustl.edu A 
        - points to the production application gateway

    - NOTE: No longer needed since vip-wusm-redcap is public
        - redcap7.wustl.edu CNAME vip-wusm-redcap.wustl.edu 
            - points to current appp55m1.cbmi.wucon.wustl.edu host as a publicly accessible URL


### Application Gateway Configuration
    - VNet - unique per resource group
    - Public IP - unique per gateway

#### Backend Pools
    - appservice (aka: pocservices)
        - target type: App Services
        - target: select the corresponding app service 
    - version7 (aka: redcap)
        - target type: FQDN
        - target: vip-wusm-redcap.wustl.edu
#### HTTP settings
    - http-setting
        - Protocol: HTTP
        - Port: 80
        - Override Path: false
        - Override Host: false
    - prod-setting - 
        - Protocol: HTTPS
        - Port: 443
        - CA Cert: true
        - Override Path: /redcap/srvrs/prod_v3_1_0_001/redcap/
        - Override Host: true
        - Host name: Pick from target
    - dev-setting - 
        - Protocol: HTTPS
        - Port: 443
        - CA Cert: true
        - Override Path: /redcap/srvrs/dev_v3_1_0_001/redcap/
        - Override Host: true
        - Host name: Pick from target
    - app-service-setting - 
        - Protocol: HTTPS
        - Port: 443
        - CA Cert: true
        - Override Path: /
        - Override Host: true
        - Host name: rcpoc3dhi4ewj6lq3rg.azurewebsites.net

### IP Address
    - Public
    - http and https listeners

#### Listeners
    - https-listener
        - IP: Public
        - Port: 443
        - Protocol: HTTPS
        - Certificate: *.wustl.edu
        - Rule: main-rule
        - Type: Basic
    - http-listener (aka: main-listener)
        - IP: Public
        - Port: 80
        - Protocol: HTTP
        - Rule: None
        - Type: Basic

#### Rules
The order of the Path Based Rules matters. The Home rule can be adjusted to point to a static site that hosts a landing page if we decide to go that route.

    - main-rule:
        - Listener: https-listener
        - Backend Targets
            - Type: Backend Pool
            - Target: appservice
            - HTTP Settings: app-service-settings
        - Path Based Rules
            - Dev7
                - Path: /redcap/srvrs/dev_v3_1_0_001/redcap/,/redcap/srvrs/dev_v3_1_0_001/redcap/*
                - HTTP Setting: dev-settings
                - Backend Pool: version7
            - Prod7
                - Path: /redcap/srvrs/prod_v3_1_0_001/redcap/,/redcap/srvrs/prod_v3_1_0_001/redcap/*
                - HTTP Setting: prod-settings
                - Backend Pool: version7
            - Default
                - Path: /redcap/*,/redcap,/redcap/current
                - HTTP Setting: app-service-settings
                - Backend Pool: appservice
            - Home
                - Path: /*
                - HTTP Setting: app-service-settings
                - Backend Pool: appservice