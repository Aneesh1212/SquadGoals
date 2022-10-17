module.exports = {
  root: true,
  env: {
    es2017: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
    "quotes": ["warn", "double"],
    "indent": ["warn"],
    "max-len": ["warn"],
    "guard-for-in": ["warn"],
  },
};
