import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Model to store authentication credentials to be linked to a existing email
/// account in firebasebase authentication
class LinkCredentials {
  String email;
  List<String> providers;
  AuthCredential credentialToLink;

  LinkCredentials({
    @required this.email,
    @required this.providers,
    @required this.credentialToLink,
  });
}
