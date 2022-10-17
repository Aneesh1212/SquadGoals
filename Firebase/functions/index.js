const functions = require("firebase-functions");
// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");

// const serviceAccount = require("/Users/aneeshagrawal/Documents/SquadGoals/Firebase/squadgoals-b30da-firebase-adminsdk-bocwr-1eecde8645.json");

/* admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://squadgoals-b30da-default-rtdb.firebaseio.com",
}); */

admin.initializeApp();

/**
 * @param {string} title
 *  @param {string} body
 */
function sendMessageToAllUsers(title, body) {
    const db = admin.database();
    const ref = db.ref("fcmTokens");
    ref.on(
        "value",
        (snapshot) => {
            const fcmTokenMap = snapshot.val();
            for (const key in fcmTokenMap) {
                const fcmToken = fcmTokenMap[key].token;
                const payload = {
                    token: fcmToken,
                    notification: {
                        title,
                        body,
                    },
                    data: {
                        body,
                    },
                };
                admin
                    .messaging()
                    .send(payload)
                    .then((response) => {
                        // Response is a message ID string.
                        console.log("Successfully sent message:", response);
                        return {
                            success: true,
                        };
                    })
                    .catch((error) => {
                        console.log(error);
                        return {
                            error: error.code,
                        };
                    });
            }
        },
        (errorObject) => {
            console.log(`The read failed: ${errorObject.name}`);
        },
    );
}


/**
 * @param {string} title
 *  @param {string} body
 *   @param {array} phoneNumbers
 */
function sendMessageToSomeUsers(title, body, phoneNumbers) {
    const db = admin.database();
    const ref = db.ref("fcmTokens");
    ref.on(
        "value",
        (snapshot) => {
            const fcmTokenMap = snapshot.val();
            for (const key in fcmTokenMap) {
                if (phoneNumbers.includes(key)) {
                    const fcmToken = fcmTokenMap[key].token;
                    const payload = {
                        token: fcmToken,
                        notification: {
                            title,
                            body,
                        },
                        data: {
                            body,
                        },
                    };
                    admin
                        .messaging()
                        .send(payload)
                        .then((response) => {
                            // Response is a message ID string.
                            console.log("Successfully sent message:", response);
                            return {
                                success: true,
                            };
                        })
                        .catch((error) => {
                            console.log(error);
                            return {
                                error: error.code,
                            };
                        });
                }
            }
        },
        (errorObject) => {
            console.log(`Send message to some users failed: ${errorObject.name}`);
        },
    );
}


/**
 * @param {string} groupId
 * @return {array}
 */
function getPhoneNumbersForGroupId(groupId) {
    const phoneNumbers = [];
    const db = admin.database();
    const ref = db.ref(`groups/${groupId}/users`);
    const snapshot = ref.once("value");
    const usersMap = snapshot.val();
    for (const key in usersMap) {
        phoneNumbers.push(usersMap[key]);
    }
    return phoneNumbers;
}

/**
 *
 */
async function getResults() {
    const db = admin.database();
    const resultsRef = db.ref(`results`);
    const snapshot = await resultsRef.once("value");
    const data = snapshot.val();
    for (const groupId in data) {
        const teamPercentage = Math.round(data[groupId].teamPercentage * 100);
        const winner = data[groupId].winner;
        const winnerPercentage = Math.round(data[groupId].winnerPercentage * 100);
        const phoneNumbers = await getPhoneNumbersForGroupId(groupId);
        sendMessageToSomeUsers("Squad Goals: Week Results!", `${winner} was the MVP this week with ${winnerPercentage}% done!
          Congratulate them on a job well done. The team percentage was ${teamPercentage}%`, phoneNumbers);
    }
}

exports.mondayEvening = functions.pubsub
    .schedule("0 21 * * 1")
    .timeZone("America/New_York")
    .onRun((context) => {
        sendMessageToAllUsers(
            "Squad Goals: Monday Check In",
            "Did you finish your tasks today? Create some momentum by crossing a few off",
        );
    });

exports.fridayMorning = functions.pubsub
    .schedule("0 11 * * 5")
    .timeZone("America/New_York")
    .onRun((context) => {
        sendMessageToAllUsers(
            "Squad Goals: Friday Motivation",
            "Before the weekend starts, let's maintain our good habits. Check in on your goals and progress",
        );
    });

exports.sundayMorning = functions.pubsub
    .schedule("0 11 * * 0")
    .timeZone("America/New_York")
    .onRun((context) => {
        sendMessageToAllUsers(
            "Squad Goals: Last Day of the Week",
            "Happy Sunday! Last day to cross off your goals and check in on your squad",
        );
    });

exports.results = functions.pubsub
    .schedule("0 20 * * 0")
    .timeZone("America/New_York")
    .onRun((context) => {
        getResults();
    });
