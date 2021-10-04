const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.myFunction = functions.firestore
  .document('assignments/{aid}')
  .onCreate((snapshot, context) => {
    return admin.messaging().sendToTopic('assignments', {
      notification: {
        title: "New Navigation Assistance Request",
        body: `${snapshot.data().VI_displayName} needs your help!`,
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      },
    });
  });
