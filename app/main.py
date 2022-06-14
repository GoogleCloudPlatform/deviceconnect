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

"""Provides the flask main routines along with core app configuration.

Provides flask's application main along with global configuration.
Provides the core user routes for login/logout.

Configuration:

    the following environment variables are read by this module:

        * `FRONTEND_ONLY`: optional, if specified, only deploy the routes
            required for user-facing functionality.
        * `BACKEND_ONLY`: optional, if specified, only deploy backend routes
            used for data ingestion.
        * `DEBUG`: if set, configure debug logging globally

Routes:

    / (index) - if logged in, show user status, if not, redirect to splash
    /splash - show application splash page and login button

    the rest of the routes are provided by other modules.
"""
import os
import logging
from flask import Flask, session, redirect, render_template, request, url_for
from werkzeug.middleware.proxy_fix import ProxyFix
from flask_dance.contrib.fitbit import fitbit

from .fitbit_auth import bp as fitbit_auth_bp, fitbit_bp
from .frontend import bp as frontend_bp
from .fitbit_ingest import bp as fitbit_ingest_bp


#
# configuration
#
app = Flask(__name__)
app.secret_key = "b9718561170654e9cc5d2594ecd36a1264760b890a415546cd0ef9cc716e4c15"  # pylint: disable=line-too-long

# fix for running behind a proxy, such as with cloudrun
app.wsgi_app = ProxyFix(app.wsgi_app)

#
# setup blueprints and routes
#
app.register_blueprint(fitbit_auth_bp)
app.register_blueprint(fitbit_bp, url_prefix="/services")  # from flask-dance
if not os.environ.get("FRONTEND_ONLY"):
    app.register_blueprint(fitbit_ingest_bp)
if not os.environ.get("BACKEND_ONLY"):
    app.register_blueprint(frontend_bp)

#
# configure logging
#
if os.environ.get("DEBUG"):
    logging.basicConfig(level=logging.DEBUG)

#
# main routes
#


@app.route("/splash")
def splash():
    return render_template("splash.html")


@app.route("/")
def index():
    """Show user's fitbit linking status, or spash page"""

    if os.environ.get("BACKEND_ONLY"):
        return "no frontend configured"

    user = session.get("user")

    if not user:
        return redirect(url_for("splash"))

    fitbit_bp.storage.user = user["email"]
    if fitbit_bp.session.token:
        del fitbit_bp.session.token

    return render_template(
        "home.html",
        user=user,
        app_name=request.host_url,
        is_fitbit_registered=fitbit.authorized,
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0")
