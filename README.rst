
===================
Project Description
===================

This project contains the open source implementation of
`Device Connect for Fitbit`_ packaged solution, and includes the following
capabilities:

  * provides end-user enrollment, consent management and Fitbit device linking,
  * provides a data connecter that ingests data from the Fitbit Web-APIs and
    pushes to Cloud BigQuery,
  * provides looker dashboards for visualizing participants data in specific or
    in aggregate.

This is an implementation of the Device Connect reference architecture, simplified
a bit to make it easy to customize and to deploy.

This is provided as **an example** and is not intended to be a *production*
implementation.  It can serve as a baseline for further development.

Additional features provided by this implementation:

  * support for connecting to patient management systems using OpenID Connect.
    The deployment instructions use `Google OIDC`_ but any OIDC can be
    configured.
  * daily data ingestion by default, but can be easily customized.  However, this
    is not intended for real-time use cases.
  * stable storage for oauth2 tokens provided by Cloud FireStore, with automatic
    token renewal.

This implementation leverages Google Cloud services:

  * Cloud Run for hosting the enrollment website and ingestion apis,
  * FireStore for stable storage of auth tokens,
  * BigQuery for long term storage and analysis of Fitbit data,
  * Looker for visualization and dashboards.

.. _Device Connect for Fitbit:
  https://cloud.google.com/device-connect
.. _Google OIDC:
  https://developers.google.com/identity/protocols/oauth2/openid-connect
