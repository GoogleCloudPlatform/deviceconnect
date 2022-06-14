
.. _configuration:

=============
Configuration
=============

The following environment variables will need to be defined:

GOOGLE_CLOUD_PROJECT
    this points to the GCP project where the application will be deployed

GOOGLE_APPLICATION_CREDENTIALS (optional)
    path to json file that holds the service account details for accessing GCP services.  
    If not defined, will use application default credentials.

BIGQUERY_DATASET
    Name of the dataset in BigQuery to use to ingest fitbit data.  
    typically this will be `fitbit`

FIRESTORE_DATASET
    Name of the dataset in Cloud Firestore to save tokens.  Typically this will
    be `tokens`

FITBIT_OAUTH_REDIRECT_URL
    this will be the internet accessible location of this app.

FITBIT_OAUTH_CLIENT_SECRET
    provided by Fitbit at http://dev.fitbit.com/ when registering the app

FITBIT_OAUTH_CLIENT_ID
    provided by Fitbit at http://dev.fitbit.com/ when registering the app


OPENID_AUTH_METADATA_URL
    Openid Connect Metadata URL, provided by the service provider.

OPENID_AUTH_CLIENT_ID
    OpenID Connect client id. provided by the service provider.
    
OPENID_AUTH_CLIENT_SECRET
    OpenID Connect client secret. provided by the service provider.

OPENID_AUTH_ALLOW_LIST (optional)
    a path to a json file with an array of email addresses to allow 
    to use the site.  if not defined, any user who successfully authenticates
    with the backend service can use the site.

FRONTEND_ONLY
    deploy only the user-facing portion of the app.  the data ingestion routes
    will not be deployed.  

BACKEND_ONLY
    deploy only the backend data ingestion routes.  The user-facing routes will
    not be deployed.

DEBUG
    if defined, will set the logger to debug mode to show extensive runtime information.

Deploying for development
=========================

The above environement variables can be added to `.env`

.. literalinclude:: ../../.env-example

