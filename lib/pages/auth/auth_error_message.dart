import 'package:firebase_auth/firebase_auth.dart';

String authErrorMessage(FirebaseAuthException error) {
  switch (error.code) {
    case 'email-already-in-use':
      return 'Cette adresse e-mail possède déjà un compte.';
    case 'invalid-email':
      return 'L’adresse e-mail n’est pas valide.';
    case 'weak-password':
      return 'Le mot de passe doit contenir au moins 6 caractères.';
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'Adresse e-mail ou mot de passe incorrect.';
    case 'user-disabled':
      return 'Ce compte a été désactivé.';
    case 'network-request-failed':
      return 'Connexion impossible. Vérifie ta connexion Internet.';
    case 'too-many-requests':
      return 'Trop de tentatives. Réessaie un peu plus tard.';
    default:
      return 'L’authentification a échoué (${error.code}).';
  }
}
