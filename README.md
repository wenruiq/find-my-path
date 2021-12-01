# Team Pathfinders - FindMyPath
FindMyPath is a mobile application developed for Etch Empathy during the undertaking of IS483 IS Project Experience (Final Year Project) at Singapore Management University.

Initiated in AY2021/2022 Term 1.

# Introduction
Welcome to the code repository for FindMyPath.

This project is a proof-of-concept mobile application which allows vision impaired users to make requests for help, connecting them to available volunteers within their country. Using real-time location services, live video/audio feed, and a built-in messaging system, the volunteer can help guide the vision impaired to their desired destination safely.

## Background
This project uses Flutter, an open-source UI software development kit created by Google, for its frontend interface and Firebase, a Backend-as-a-Service app development platform for its backend needs.

# Configuration

## Dependencies
To run the application, the following needs to be installed:

- Visual Studio Code (VSC)
- Flutter (follow the instructions at https://docs.flutter.dev/get-started/install)
- Android Studios (instructions included in Flutter installation guide as well)
- iOS Simulator for Windows (Mac users can use the inbuilt Simulator app)

You will also need a Firebase account if you don't have one. (https://firebase.google.com/)

## VSC Configuration

If you have worked on Flutter projects before, skip this section

- Go to Extensions
- Search for "Dart" and "Flutter"
- Install both extensions

## Launch Guide

- Ensure that your android emulator is launched (or plug in a real android device)
- At the bottom right hand corner of VSC, check that your emulator is detected (as shown below)

![image](https://user-images.githubusercontent.com/54570187/144275026-7dad6be6-2937-4859-96b0-1d2b8b25e0b7.png)


- Open terminal at the root directory of the project and run the following commands

```
flutter pub get
flutter run
```
- The build process will take awhile the first time so don't worry
- FindMyPath should successfully boot up in your emulator

(Preferred) Alternatively, to launch the project, you can click into any .dart files in the repository, go to the top toolbar of VSC > Run > Run Without Debugging. This opens a floating control panel in VSC (as shown below) which allows you to perform Hot Restarts with ease.

![image](https://user-images.githubusercontent.com/54570187/144275072-e98a516b-dafc-45c6-a5ab-d63e2a1cacb3.png)

## Firebase CLI Setup Guide

If you prefer to work with Firebase using the terminal, you can configure firebase as shown below

``` 
# first create project in your own firebase account 

npm install -g firebase-tools #install firebase cli

firebase login 

firebase projects:list # view list of project 

firebase use --add #add in firebase project  

firebase serve 
```

# Repository Folder Structure

```
/assets - images used
/fonts - special fonts used
/functions - Firebase cloud functions
/lib - source code

/lib/main.dart - home page
/lib/providers - data model for common objects
/lib/screens - all the screens that users can see
/lib/theme - customize colour theme and configurations
/lib/widgets/[feature] - widgets used for a specific feature
```

# Firestore Data Structure

```
users/[userID] - All user details are stored here (does not include passwords)
users/[userID]/requests - All completed requests by a specific user are stored here

requests/[requestID] - All requests (Pending/Ongoing/Completed) are stored here
requests/[requestID]/messages - All messages sent in the chat room are stored here
requests/[requestID]/call - A document used for storing call state

```
