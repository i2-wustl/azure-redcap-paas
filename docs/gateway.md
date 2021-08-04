# Application Gateway Configuration 
    - VNet - unique per resource group
    - Public IP - unique per gateway

## Backend Pools
    - appservice (aka: pocservices)
        - target type: App Services
        - target: select the corresponding app service 
    - version7 (aka: redcap)
        - target type: FQDN
        - target: vip-wusm-redcap.wustl.edu
## HTTP settings
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
        - CookieAffinity

## IP Address
    - Public
    - http and https listeners

## Listeners
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

## Rules
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

## References

https://techcommunity.microsoft.com/t5/apps-on-azure/setting-up-application-gateway-with-an-app-service-that-uses/ba-p/392490