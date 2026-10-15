# NewMusicApp – Documentation du projet

## 1. Informations générales
- Projet : NewMusicApp
- Développeur : Belibi Engozo’o Robert Ulriche
- Structure / entité : YETI Sangmelima
- Période de développement : 3 semaines
- Type d’application : application mobile de lecture musicale

## 2. Objectif du projet
NewMusicApp vise à concevoir une application mobile de musique très simple, fonctionnelle et agréable à utiliser. L’objectif principal est de proposer une expérience de lecture audio, une gestion efficace des favoris, la création et l’organisation de playlists, ainsi qu’un accès utilisateur sécurisé via authentification.

## 3. Programme détaillé du projet (de la base jusqu’à la finalisation)
Le projet a été développé selon le programme complet, en suivant les étapes de conception, de réalisation et de finalisation.

### Phase 1 – Modules hors ligne (0 à 6)
Cette phase concerne le développement local, sans dépendance directe à Internet. Elle permet de concevoir la base de l’application, les modèles, les écrans et les fonctions de lecture musicale.

#### Module 0 – Mise en place
- Création du projet Flutter.
- Ouverture du projet dans VS Code.
- Vérification du lancement de l’application sur navigateur ou émulateur.
- ajout de la dépendance just_audio.
- création de la structure projet : common/widgets, models, pages/auth, pages/home, services, assets/images, assets/audio.
- compréhension du fonctionnement de setState.
- validation de la première page fonctionnelle avec un compteur.

#### Module 1 – Modèles et données locales
- création du modèle Song avec les propriétés suivantes : id, titre, artiste, imageUrl, audioUrl, duree.
- création du modèle User avec id, email, nom.
- préparation d’une liste locale de 5 chansons exploitable dans l’application.
- mise en place des données locales pour alimenter les écrans.

#### Module 2 – Interface d’accueil
- création du widget SongCard.
- mise en place d’une carte avec image, titre, artiste et informations de base.
- conception de la page d’accueil HomePage.
- affichage dynamique de la liste de chansons avec ListView.builder.
- validation de l’affichage des 5 morceaux sur l’écran d’accueil.

#### Module 3 – Lecteur audio local
- création de la page SongPage.
- initialisation de l’AudioPlayer.
- chargement des fichiers audio depuis les assets locaux.
- gestion de l’état de lecture avec isPlaying, position et durée.
- affichage de la pochette, du titre, de l’artiste et du slider de lecture.
- mise en place du bouton play/pause et de la logique de seek.

#### Module 4 – Navigation
- navigation de HomePage vers SongPage.
- ajout du routeur de base dans le fichier principal.
- configuration du thème visuel de l’application.
- validation du parcours entre écrans.

#### Module 5 – Favoris
- création d’un gestionnaire de favoris en mémoire.
- ajout et suppression d’une chanson dans la liste des favoris.
- bouton cœur sur chaque carte pour ajouter ou retirer un morceau.
- création d’une page Favoris avec affichage des titres ajoutés.
- gestion de l’état visuel lorsque la chanson est favorite.

#### Module 6 – Playlists
- création du modèle Playlist.
- gestionnaire de playlists en mémoire.
- création d’une playlist avec nom personnalisé.
- ajout de chansons dans une playlist.
- création de la page Playlists avec bouton d’ajout.
- validation du parcours de création et mise en forme des listes.

### Phase 2 – Modules en ligne (7 à 10)
Cette phase porte sur la migration vers une version plus professionnelle avec Firebase, Firestore et stockage des médias.

#### Module 7 – Firebase Auth
- création du projet Firebase.
- activation de l’authentification par email et mot de passe.
- ajout des dépendances firebase_core et firebase_auth.
- configuration Firebase avec flutterfire configure.
- création du service AuthService.
- implémentation des méthodes signUp, signIn et signOut.
- création des pages SignInPage et SignUpPage.
- création de la page ProfilePage avec bouton de déconnexion.
- validation du parcours d’inscription et de connexion.

#### Module 8 – Firestore
- ajout de la dépendance cloud_firestore.
- activation de Firestore sur Firebase.
- création de documents pour les chansons.
- création du service FirestoreService.
- récupération des données depuis la collection songs.
- conversion des documents Firestore en objets Song.
- migration des favoris et playlists vers Firestore.
- validation de la synchronisation des données depuis la base distante.

#### Module 9 – Firebase Storage
- ajout de la dépendance firebase_storage.
- activation de Firebase Storage.
- création du service StorageService.
- upload des fichiers audio.
- récupération des URL publiques pour lecture directe.
- remplacement de setAsset par setUrl dans le lecteur audio.
- remplacement des images locales par Image.network lorsque nécessaire.
- validation de la lecture en streaming.

#### Module 10 – Finition et transfert
- test complet de l’application.
- vérification des parcours suivants : inscription, connexion, lecture, favoris, playlists.
- optimisation des performances et des rebuilds.
- polissage du design et correction finale des éléments visuels.
- préparation de la version démonstrable et transfert de logique applicative vers d’autres projets ou cas d’usage.

## 4. Fonctionnalités détaillées de l’application
Les fonctionnalités principales du projet sont les suivantes :

- lecture de chansons audio,
- recherche par titre ou artiste,
- gestion des favoris,
- création et gestion de playlists,
- lecture complète d’une playlist,
- lecture aléatoire dans une playlist,
- lecture en boucle,
- navigation entre écrans,
- authentification utilisateur,
- accès invité,
- affichage du profil,
- interface mobile adaptée au format téléphone.

## 5. Logique de fonctionnement
L’application suit une logique simple et cohérente :

- l’utilisateur ouvre l’application et accède à l’écran d’accueil ;
- les chansons sont affichées dans une liste locale puis, plus tard, depuis Firestore ;
- il peut choisir un morceau pour l’écouter dans le lecteur ;
- il peut l’ajouter aux favoris ou l’intégrer à une playlist ;
- le lecteur audio gère lecture, pause, progression et lecture en boucle ;
- les utilisateurs peuvent créer un compte ou se connecter ;
- les données personnelles sont stockées dans Firebase et Firestore, ce qui permet d’alimenter les favoris et les playlists de manière structurée.

## 6. Backend utilisé
Le projet utilise Firebase et Firestore comme base backend.

### Firebase
- gestion de l’authentification,
- gestion des comptes utilisateur,
- prise en charge de l’inscription et de la connexion.

### Firestore
- stockage des données utilisateur,
- sauvegarde et lecture des favoris,
- gestion des playlists,
- conservation des contenus personnels et cohérents entre sessions.

### Firebase Storage
- stockage des fichiers audio,
- récupération des liens de lecture,
- support de la lecture en streaming.

## 7. Points essentiels du projet
Le projet NewMusicApp est fondamentalement une application musicale mobile complète, structurée en plusieurs étapes progressives. Ses points forts sont :

- organisation claire du développement,
- séparation entre interface locale et backend,
- gestion des fonctionnalités essentielles de lecture et personnalisation,
- cohérence du parcours utilisateur,
- architecture évolutive pour une future mise en production.

## 8. Pistes d’amélioration
1. Améliorer la sécurité des comptes et les règles d’accès aux données.
2. Renforcer la synchronisation des favoris et des playlists entre les sessions.
3. Ajouter des recommandations musicales et amélioration utilisateur.
4. Optimiser la gestion hors ligne pour une meilleure expérience mobile.

## 9. Conclusion
NewMusicApp a été développé en 3 semaines selon un programme détaillé allant du module 0 jusqu’au module 10. Le projet suit une progression logique : création de la base, conception de l’interface, ajout du lecteur audio, gestion des favoris et playlists, puis intégration de Firebase et Firestore pour une version plus réaliste et évolutive. Il s’agit d’une application musicale structurée, fonctionnelle et prête à être étendue dans un cadre de développement professionnel.
