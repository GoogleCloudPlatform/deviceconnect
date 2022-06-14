
.. _requirements:

============
Requirements
============

You will need the following before
development or deployment:

* Fitbit developer account

    Start at http://dev.fitbit.com/apps and after logging in, register a
    new application, providing the details required (you can edit them later).

    The most important bits that you need are the `OAUTH 2.0 Client ID`,
    the `Client Secret` and the `Redirect URL`.

    You will likely need at least two developer accounts, one for development
    with a redirect url = `localhost`, and one for production with the redirect
    url = public domain name of the service.

    .. Note::
        Intraday data for heartrate, breathing, and activity data are not
        available by default.  see
        https://dev.fitbit.com/build/reference/web-api/intraday/ to request
        access for your production and/or development service accounts.

* GCP Project

    A GCP project needs to be provided with the appropriate services enabled:

    * Cloud Firestore

        for the user login credentials and the device tokens.

    * BigQuery

        for device data

    * GKE and Cloud Functions (or Cloud Run and GCE)

        for running the onboarding and ingestion services

    * Cloud Scheduler

        for triggering the batch ingestion

    * GCP Service Account (optional)

        a account key in JSON format
        is used to access the GCP services.  If missing, will use the
        compute default account which should work if everything is running
        in the same project.

* OpenID Connect provider:

    you will need some authentication provider.  You can use Google's service
    or if your organization has a patient managment system, you will need to
    talk with the administrators of that service.

    Currently this only supports Openid Connect.
