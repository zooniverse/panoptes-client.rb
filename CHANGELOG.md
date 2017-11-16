# 0.3.3

* `client.get_subject_classifications` now paginates if there is more than one page

# 0.3.2

?

# 0.3.1

* Automatically loads active public key (as of gem release)

# 0.2.10

* Fix bug with server errors

# 0.2.9

* Be compatible with JRuby

# 0.2.8

* Merged Client and TalkClient: `client.discussions` is now just on Client. TalkClient is still present as an alias for Client
* Add `client.create_comment` to post a comment in a talk discussions
* Add `client.current_user` to get information contained in the authentication token, if given
* Add `client.cellect_workflows` to get information on workflows using the cellect services
* Add `client.cellect_subjects` to get subject information for a given cellect workflow

# 0.2.7

* Add `TalkClient` to interact with the talk api.
* Add `client.discussions` to fetch talk discussions for a focus object.
* Refactored the client connection code for re-use between talk and panoptes clients.

# 0.2.6

* Add `client.workflow` to fetch a specific workflow.
* Add `client.create_workflow`
* Add `client.subjects` to fetch a list of subjects given filters
* Add `client.subject_set` to fetch a specific subject set
* Add `client.create_subject_set`
* Add `client.update_subject_set`
* Add `client.add_subjects_to_subject_set`
* ServerErrors will now have the error message in the exception message

# 0.2.5

* Add `client.remove_user_from_user_group` that can be used by group admins to remove some other user from a group.
* Add `client.delete_user_group` to remove a user group.

# 0.2.4

* Add support for the new retirement reason field

# 0.2.3

* Add methods for creating project data exports

# 0.2.2

* ?

# 0.2.1

* Fix bug with token authentication

# 0.2.0

* Raise errors on certain server response statuses.
* Add put/patch/delete requests.

# 0.1.2

* Fix bug with client_id/client_secret authentication

# 0.1.1

* Added wrapper file so Bundler's automatic require works.

# 0.1.0

* Initial release. Supports only a small amount of API calls (apart from the generic get/post calls).
