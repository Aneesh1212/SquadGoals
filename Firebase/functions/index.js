const functions = require("firebase-functions");
// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");

// const serviceAccount = require("/Users/aneeshagrawal/Documents/SquadGoals/Firebase/squadgoals-b30da-firebase-adminsdk-bocwr-1eecde8645.json");

/* admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://squadgoals-b30da-default-rtdb.firebaseio.com",
}); */

admin.initializeApp();
const db = admin.database();
const currentDate = Math.round(Date.now() / 1000);
const dayOfWeek = mod(((new Date()).getDay() - 1), 7);
const daysLeftInWeek = 7 - dayOfWeek;
const secondsPerDay = 86400;


function mod(n, m) {
    return ((n % m) + m) % m;
}

/**
 * @param {string} title
 *  @param {string} body
 */
function sendMessageToAllUsers(title, body) {
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
                        return {
                            success: true,
                        };
                    })
                    .catch((error) => {
                        return {
                            error: error.code,
                        };
                    });
            }
        },
        (errorObject) => {},
    );
}


/**
 * @param {string} title
 *  @param {string} body
 *   @param {array} phoneNumbers
 */
function sendMessageToSomeUsers(title, body, phoneNumbers) {
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
                            return {
                                success: true,
                            };
                        })
                        .catch((error) => {
                            return {
                                error: error.code,
                            };
                        });
                }
            }
        },
        (errorObject) => {},
    );
}


/**
 * @param {string} groupId
 * @return {array}
 */
function getPhoneNumbersForGroupId(groupId) {
    const phoneNumbers = [];
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

/**
 * @param {int} creationDate
 * @return {boolean}
 */
function isTargetInThisWeek(creationDate) {
    const differenceInSeconds = currentDate - creationDate;
    const differenceInDays = Math.floor(differenceInSeconds / secondsPerDay);
    return differenceInDays <= dayOfWeek
}

/**
 * @param {string} goalKey
 * @return {Promise<dictionary>}
 */
async function getTargetsForGoalKey(goalKey) {
    const goalRef = db.ref(`targets/${goalKey}`);
    var totalTargets = 0;
    var finishedTargets = 0;
    var goalMap = await (await goalRef.get()).val();
    for (const targetKey in goalMap) {
        const target = goalMap[targetKey];
        const targetCreationDate = parseInt(target.creationDate);
        if (isTargetInThisWeek(targetCreationDate)){
            totalTargets += parseInt(target.original);
            finishedTargets += (parseInt(target.original) - parseInt(target.frequency));
        }
    }
    return {"totalTargets": totalTargets, "finishedTargets": finishedTargets};
}

function calculateMomentumChanges(totalTasks, finishedTasks, positiveMomentum, negativeMomentum, momentumScore, crossedOff) {
    if (!crossedOff && (((totalTasks - finishedTasks) >= daysLeftInWeek) || (totalTasks == 0 && dayOfWeek > 2))) {
        momentumScore = max(0, momentumScore - negativeMomentum);
        positiveMomentum = max(1, positiveMomentum - 1);
        negativeMomentum = negativeMomentum - 1;
        }
    return {"momentumScore": momentumScore.toString(), "positiveMomentum": positiveMomentum.toString(), "negativeMomentum": negativeMomentum.toString(), "crossedOff": "false"};
}

async function updateMomScore() {
    const usersRef = db.ref("goals");
    var goalsMap = await (await usersRef.get()).val();
    for (const userPhoneNumber in goalsMap) {
        const goalMap = goalsMap[userPhoneNumber].goals;
        for (const goalKey in goalMap) {
            const goal = goalMap[goalKey];
            const targetData = await getTargetsForGoalKey(goalKey);
            const crossedOff = goal.crossedOff == "true" ? true : false;
            const positiveMomentum = goal.positiveMomentum != undefined ? parseInt(goal.positiveMomentum) : 0
            const negativeMomentum = goal.negativeMomentum != undefined ? parseInt(goal.negativeMomentum) : 0
            const momentumScore = goal.momentumScore != undefined ? parseInt(goal.momentumScore) : 0
            const momentumData = calculateMomentumChanges(targetData.totalTargets, targetData.finishedTargets, positiveMomentum, negativeMomentum, momentumScore, crossedOff);
            const goalRef = db.ref(`goals/${userPhoneNumber}/goals/${goalKey}`)
            goalRef.update(momentumData);
        }
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

exports.calculateMomentum = functions.pubsub
    .schedule("0 1 * * *")
    .timeZone("America/New_York")
    .onRun((context) => {
        updateMomScore();
    });
