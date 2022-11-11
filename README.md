<p align="center">
  <a align="center" href="https://youtu.be/_0UtxdBEp9M?t=21" target="_blank"> <img src="https://user-images.githubusercontent.com/58852708/199702596-44521737-fee3-4abe-8359-f05048072333.png" alt="Watch the video" width="480" height="270" border="10" target="_blank" /></a>
    </br>
    (Click Image to View YouTube Demo)
</p>
 
<h3 align="center">Find My Path</h3>
<p align="center">
  Crowd-sourced Navigation Mobile App for the Vision Impaired
  </br>
  </br>
  Co-developed by <a href="https://github.com/wenruiq">Wenrui</a> and <a href="https://github.com/lifuhuang97">Lifu</a> for non-profit organisation -  <a href="https://www.etch.sg/">Etch Empathy</a>
  </br>
  </br>
  <a href="https://github.com/wenruiq/find-my-path">Explore the docs</a> · 
  <a href="https://github.com/wenruiq/find-my-path/issues">Report Bug</a> ·
  <a href="https://github.com/wenruiq/find-my-path/issues">Request Feature</a>
  </br>
  </br>
  </br>
  <img align="center" src="https://user-images.githubusercontent.com/58852708/201275895-178d9c59-4200-447e-a2f9-e7dacbc1117f.png"/ width="500px">
</p>


<!-- TABLE OF CONTENTS -->
## Table of Contents
* [About the Project](#about-the-project)
* [Built With](#built-with)
* [Key Features](#key-features)
  * [Login](#login)
  * [Requesting for Help (Vision Impaired User)](#requesting-for-help-vision-impaired-user)
    * [Search for Destination](#search-for-destination)
    * [Attach Photo and Submit Request](#attach-photo-and-submit-request)
  * [Accepting a Request (Volunteer User)](#accepting-a-request-volunteer-user)
    * [Push Notifications](#push-notifications)
    * [Accept a Request](#accept-a-request)
    * [Messaging and Location Sharing](#messaging-and-location-sharing)
  * [Write a Reviews](#write-a-reviews)
* [Getting Started](#getting-started)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)

## About the Project

Find My Path is an MVP mobile app designed to connect the 50,000+ visual impaired people in Singapore to volunteers for navigational assistance.

Using real-time location services, live video/audio feed, and a built-in text & image messaging system, the volunteer can help guide the vision impaired user to their desired destinations safely.

A strong emphasis is placed on providing excellent <b>accessibility support</b> for the users, especially in terms of screen-reading capabilities.

## Built With
* [Flutter](https://flutter.dev/)
* [Firebase](https://firebase.google.com/)
* [Google Places](https://developers.google.com/maps/documentation/places/web-service/overview)
* [Google Directions](https://developers.google.com/maps/documentation/directions/overview)
* [Agora](https://www.agora.io/en/)

## Key Features
### Login
<img src="http://g.recordit.co/IhEny78so1.gif" width="300px"/>

### Requesting for Help (Vision Impaired User)

#### Search for Destination
<img src="http://g.recordit.co/iRLizcrbcx.gif" width="300px"/>

#### Attach Photo and Submit Request
<img src="http://g.recordit.co/UmMrm1CIX2.gif" width="300px"/>

### Accepting a Request (Volunteer User)
#### Push Notifications
<img src="http://g.recordit.co/PBBh4htITo.gif" width="300px"/>

#### Accept a Request
<img src="http://g.recordit.co/1ZbE17k7pS.gif" width="300px"/>

#### Messaging and Location Sharing
<img src="http://g.recordit.co/wpUgJoAU2f.gif" width="300px"/>

### Write a Review
<img src="http://g.recordit.co/1a3iMRZjHG.gif" width="300px"/>




## Getting Started

### Dependencies
To run the application, the following needs to be installed:

- Visual Studio Code (VSC)
- Flutter (follow the instructions at https://docs.flutter.dev/get-started/install)
- Android Studios (instructions included in Flutter installation guide as well)
- iOS Simulator for Windows (Mac users can use the inbuilt Simulator app)

You will also need a Firebase account if you don't have one. (https://firebase.google.com/)

### VSCode Configuration

If you have worked on Flutter projects before, skip this section

- Go to Extensions
- Search for "Dart" and "Flutter"
- Install both extensions

### Launch Guide

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

### Firebase CLI Setup Guide

If you prefer to work with Firebase using the terminal, you can configure firebase as shown below

``` 
# first create project in your own firebase account 

npm install -g firebase-tools #install firebase cli

firebase login 

firebase projects:list # view list of project 

firebase use --add #add in firebase project  

firebase serve 
```

### Repository Folder Structure

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

### Firestore Data Structure

```
users/[userID] - All user details are stored here (does not include passwords)
users/[userID]/requests - All completed requests by a specific user are stored here

requests/[requestID] - All requests (Pending/Ongoing/Completed) are stored here
requests/[requestID]/messages - All messages sent in the chat room are stored here
requests/[requestID]/call - A document used for storing call state
```
## Roadmap

See the [open issues](https://github.com/wenruiq/find-my-path/issues) for a list of proposed features (and known issues)



## Contributing

The open source community is such an amazing place for us to be inspired, learn, and create. I **greatly appreciate** any contributions you make to this project!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AwesomeFeatures`)
3. Commit your Changes (`git commit -m 'Added some awesome features'`)
4. Push to the Branch (`git push origin feature/AmazingFeatures`)
5. Open a Pull Request



## License
Distributed under the **[MIT license](http://opensource.org/licenses/mit-license.php)**



## Contact

Wenrui - wenrui119@gmail.com

Lifu - lifuhuang97@gmail.com

Project Link: [https://github.com/wenruiq/find-my-path](https://github.com/wenruiq/find-my-path)

