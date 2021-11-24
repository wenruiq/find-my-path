const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.requestNotificationFunction = functions
    .region('asia-southeast1')
    .firestore.document('requests/{rid}')
    .onCreate((snapshot, context) => {
        return admin.messaging().sendToTopic('requests', {
            notification: {
                title: 'New FindMyPath Request',
                body: `${snapshot.data().VI_displayName} needs your help!`,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            },
            data: {
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            },
        });
    });
