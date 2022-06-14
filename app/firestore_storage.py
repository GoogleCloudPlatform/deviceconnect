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

"""Classes and functions for interfacing with Cloud Firestore.

Module provides classes for managing state in a backend firestore
dataset.  Currently this includes ``FirestoreStorage`` class.

Configuration:
    Uses the standard mechanisms to initialize google cloud authentication.
    See `Google Authentication`_

    tl;dr is that the libraries use the service account pointed to
    by the environment variable `GOOGLE_APPLICATION_CREDENTIALS`.

    If those are not set, will use default application credentials.

.. _Google Authentication:
    https://cloud.google.com/docs/authentication
"""
from flask_dance.consumer.storage import BaseStorage
import firebase_admin
from firebase_admin import firestore


#
# initializations and module globals
#

firebase_admin.initialize_app()
db = firestore.client()


class FirestoreStorage(BaseStorage):
    """Firestore backend for flask-dance oauth token storage.

        Examples of use::

            firestorage = FirestoreStorage("tokens")
            fitbit_bp = make_fitbit_blueprint(
                ...
                storage=firestorage
            )

            in this case, will use a dataset named "tokens".  If the
            dataset is not created, it will create.

            see `flask dance storage`_. for specification.

    .. _flask dance storage:
        https://flask-dance.readthedocs.io/en/latest/storages.html
    """

    def __init__(self, collection):

        super(FirestoreStorage, self).__init__()

        self.collection = db.collection(collection)
        self.user = None

    def get(self, blueprint):

        if self.user:
            doc_ref = self.collection.document(self.user)
            doc = doc_ref.get()

            if doc.exists:
                return dict(doc.to_dict())

        return {}

    def set(self, blueprint, token):

        if self.user:
            self.collection.document(self.user).set(token)

    def delete(self, blueprint):
        if self.user:
            self.collection.document(self.user).delete()

    def all_users(self):
        return [doc.id for doc in self.collection.stream()]

    def save(self, user, token):
        if user:
            self.collection.document(user).set(token)
