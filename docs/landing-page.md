## Additional Steps
- landing page
    - Deployed in the root of the current version of RC (could consider hosting a static site to decouple the landing page)
    - Contains links to current, v7 prod and v7 demo
    - Link to current version points to login.php which handles the OAuth redirect for unauthenticated users or redirects to REDCap home page if the user is already logged in.