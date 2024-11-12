# FirebaseService Documentation

This documentation provides an overview of the `FirebaseService` class, which interacts with Firebase Authentication and Firebase Realtime Database to handle user forms.

## Overview

The `FirebaseService` class provides functions to:
1. Submit a user form to Firebase Realtime Database.
2. Retrieve a user form by UID.
3. Delete a user form by UID.

It uses Firebase Authentication to manage user sessions and Firebase Realtime Database to store and retrieve data.

### Dependencies

Make sure to include the necessary Firebase dependencies in your `pubspec.yaml`:

```yaml
dependencies:
  firebase_auth: ^4.0.0
  firebase_core: ^2.0.0
  firebase_database: ^10.0.0
  ```
## Methods

### `submitUserForm(UserFormModel userForm)`
Submits, or updates if exists, a user form to the Firebase Realtime Database under the path `user_forms/{uid}`.

- **Parameters**:
    - `userForm`: A `UserFormModel` instance to be submitted.

- **Returns**:
    - `Future<void>` - A future that completes once the form is successfully submitted.

- **Throws**:
    - An error if submission fails.

---

### `getUserUID()`
Retrieves the UID of the currently authenticated user.

- **Returns**:
    - `Future<String?>` - A future that resolves to the user UID if the user is logged in, or `null` if no user is logged in.

- **Throws**:
    - None.

---

### `getUserFormByUID(String uid)`
Fetches the user form from the Firebase Realtime Database for a given UID.

- **Parameters**:
    - `uid`: The UID of the user whose form is to be fetched.

- **Returns**:
    - `Future<UserFormModel?>` - A future that resolves to the user form if found, or `null` if not found.

- **Throws**:
    - An error if fetching data fails.

---

### `deleteUserFormByUID(String uid)`
Deletes the user form data from the Firebase Realtime Database for a given UID.

- **Parameters**:
    - `uid`: The UID of the user whose form is to be deleted.

- **Returns**:
    - `Future<void>` - A future that completes once the form is successfully deleted.

- **Throws**:
    - An error if deletion fails.


