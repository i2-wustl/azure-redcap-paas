-- Run this script once the initial REDCap setup is complete
-- and an admin account has been created. 
-- NOTE: Be sure to copy the values from the shibboleth_table_config.json file and 
-- paste them into the value for the shibboleth_table_config field

UPDATE redcap_config
SET value = 'Washington University in Saint Louis'
WHERE field_name = 'institution';

UPDATE redcap_config
SET value = 'https://redcapdev.wustl.edu/redcap/'
WHERE field_name = 'redcap_base_url';

UPDATE redcap_config
SET value = 'https://connect.wustl.edu/logout/'
WHERE field_name = 'shibboleth_logout';

--NOTE: Use values from the shibboleth_table_config.json
UPDATE redcap_config
SET value = ''
WHERE field_name = 'shibboleth_table_config';

UPDATE redcap_config
SET value = 'REMOTE_USER'
WHERE field_name = 'shibboleth_username_field';


-- NOTE: Used to switch authentication method, can be left commented out
-- if the setting has already been updated manually.
-- UPDATE redcap_config
-- SET value = 'shibboleth_table'
-- WHERE field_name = 'auth_meth_global';