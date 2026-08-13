// ZION Wallet UI / Logic Module
console.log("💎 ZION Wallet Core Module Initialized");

class ZionWallet {
  constructor(initialBalance = 1000) {
    this.balance = initialBalance;
  }

  getBalance() {
    return this.balance;
  }
}

module.exports = ZionWallet;
