// ZION Short Video Feed Module
console.log(" ZION Feed Module Initialized");

const mockFeedData = [
  { id: 1, title: "ZION Teaser Video", creator: "@soulivan", likes: 120 },
  { id: 2, title: "How ZION Wallet Works", creator: "@alex", likes: 85 }
];

function loadFeed() {
  console.log("Loading video feed...");
  return mockFeedData;
}

module.exports = { loadFeed };
