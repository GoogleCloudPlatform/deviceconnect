# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""provides routes for user login using openid connect

Provides user management using OpenID Connect for authenticating users.
If successful, adds two session variables `user` and `id_token`.  The
`user` is the email address for the logged in user and can be used as
unique key.  The `id_token` is necessary for logout.  For oidc endpoints
that support `end-session-endpoint`, the `logout` method will invalidate
the oidc session.

Note that not all oidc providers provide a `end-session-endpoint`.  For
example, Google OIDC does not.  For those endpoints, there is no logout
capability.  But we add a `prompt=consent` to the kwargs for the service
so that it always asks for consent.  otherwise, once logged in, future
logins are done silently.  See `OpenID Connect Logout`_.

Routes:

    /login - redirect to openid provider website

    /redirect - after user logs in, oidc provider redirects back here

    /logout - when user logs out

Configuration:

    The following environment variables will need to be defined:

        * `OPENID_AUTH_METADATA_URL` - provided by your oidc provider
        * `OPENID_AUTH_CLIENT_ID` - provided by your oidc provider
        * `OPENID_AUTH_CLIENT_SECRET` - provided by your oidc provider
        * `OPENID_AUTH_ALLOW_LIST` - if set, points to a json file with an array
           of email addresses to admit.  all others will be denied entry.
           example::

                OPENID_AUTH_ALLOW_LIST='/secret/allowlist'
                cat /secret/allowlist
                [
                    "user1@domain.com",
                    "user2@domain.com"
                ]

.. _OpenID Connect Logout:
  https://www.googlecloudcommunity.com/gc/Cloud-Product-Articles/OpenID-Connect-Logout/

"""
import os
import logging
import json
from urllib.parse import urlencode
from flask import session, redirect, url_for, current_app, Blueprint
from authlib.integrations.flask_client import OAuth

log = logging.getLogger(__name__)

bp = Blueprint("frontend_bp", __name__)

# default to google openid provider
OPENID_AUTH_METADATA_URL = os.environ.get("OPENID_AUTH_METADATA_URL")
OPENID_AUTH_CLIENT_ID = os.environ.get("OPENID_AUTH_CLIENT_ID")
OPENID_AUTH_CLIENT_SECRET = os.environ.get("OPENID_AUTH_CLIENT_SECRET")

ONLY_ALLOW = None
if os.environ.get("OPENID_AUTH_ALLOW_LIST"):
    with open(os.environ.get("OPENID_AUTH_ALLOW_LIST")) as json_file:
        ONLY_ALLOW = json.load(json_file)

oauth = OAuth(current_app)

oauth.register(
    name="openid",
    server_metadata_url=OPENID_AUTH_METADATA_URL,
    client_id=OPENID_AUTH_CLIENT_ID,
    client_secret=OPENID_AUTH_CLIENT_SECRET,
    client_kwargs={"scope": "openid email profile", "prompt": "consent"},
)


@bp.route("/login")
def login():
    redirect_uri = url_for("frontend_bp.auth", _external=True)
    return oauth.openid.authorize_redirect(redirect_uri)


@bp.route("/redirect")
def auth():
    token = oauth.openid.authorize_access_token()

    if ONLY_ALLOW and not token["userinfo"]["email"] in ONLY_ALLOW:
        log.info(
            "user %s not in allowlist: %s",
            token["userinfo"]["email"],
            ONLY_ALLOW,
        )

        #
        # in order to logout, need to set session token
        #
        session["id_token"] = token["id_token"]

        #
        # have to hit the logout anyway to revoke any tokens
        #
        return f"User not registered for this study.  <a href='{url_for('frontend_bp.logout', _external=True)}'>click here</a>"

    log.info("user logged in: %s", str(token["userinfo"]))

    session["user"] = token["userinfo"]
    session["id_token"] = token["id_token"]

    return redirect(url_for("index", _external=True))


@bp.route("/logout")
def logout():

    id_token = session.get("id_token")
    redirect_uri = url_for("index", _external=True)

    #
    # clear session tokens
    #
    session.pop("user", None)
    session.pop("id_token", None)

    #
    # for oidc endpoints that implement end-session-endpoint, logout user
    #
    metadata = oauth.openid.load_server_metadata()
    end_session_endpoint = metadata.get("end_session_endpoint")

    if end_session_endpoint:

        params = dict(
            id_token_hint=id_token, post_logout_redirect_uri=redirect_uri
        )
        encoded_params = urlencode(params)
        end_session_url = f"{end_session_endpoint}?{encoded_params}"

        return redirect(end_session_url)

    return redirect(redirect_uri)
