const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.myFunction = functions.firestore
	.document('requests/{rid}')
	.onCreate((snapshot, context) => {
		return admin.messaging().sendToTopic('requests', {
			notification: {
				title: 'New FindMyPath Request',
				body: `${snapshot.data().VI_displayName} needs your help!`,
				clickAction: 'FLUTTER_NOTIFICATION_CLICK',
			},
		});
	});
