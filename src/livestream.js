// ZION Live Stream Module
console.log(" ZION Live Stream Module Initialized");

function startLive(streamerName) {
  console.log(`Live stream started by ${streamerName}`);
}

function sendGift(sender, recipient, coinAmount) {
  console.log(`${sender} sent ${coinAmount} ZION Coins to ${recipient}`);
}

module.exports = { startLive, sendGift };
