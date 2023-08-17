const {logger} = require("firebase-functions");
const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");

// The Firebase Admin SDK to access Firestore.
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");

initializeApp();

// Listens for new messages added to /messages/:documentId/original
// and saves an uppercased version of the message
// to /messages/:documentId/uppercase
exports.makeuppercase = onDocumentCreated("/friends/{userId}", (event) => {
    // Grab the current value of what was written to Firestore.
    const original = event.data.data().original;
  
    // Access the parameter `{documentId}` with `event.params`
    logger.log("Event!!!", event.params.documentId, original);
    
    return;
  });