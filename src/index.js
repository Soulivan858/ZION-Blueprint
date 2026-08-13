// ZION Main Application Entry Point
const { loadFeed } = require('./feed');
const { startLive, sendGift } = require('./livestream');
const ZionWallet = require('./wallet');

console.log("=================================");
console.log("    🚀 ZION APP INITIALIZED      ");
console.log("=================================\n");

// 1. Load Feed
console.log("--- 📽️ Video Feed ---");
console.log(loadFeed());

// 2. Live Stream & Wallet Demo
console.log("\n--- 🔴 Live Stream & Wallet ---");
const myWallet = new ZionWallet(1000);
startLive("Soulivan");
sendGift("Soulivan", "Alex", 50);

console.log(`\n💰 Current Wallet Balance: ${myWallet.getBalance() - 50} ZION Coins`);
