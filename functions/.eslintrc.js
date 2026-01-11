module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "google",
    "plugin:@typescript-eslint/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: ["tsconfig.json", "tsconfig.dev.json"],
    sourceType: "module",
    tsconfigRootDir: __dirname, // <--- TAMBAHKAN BARIS INI
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
    "/generated/**/*", // Ignore generated files.
  ],
  plugins: [
    "@typescript-eslint",
    "import",
  ],
  rules: {
    "quotes": ["error", "double"],
    "import/no-unresolved": 0,
    "indent": "off", // Matikan aturan indentasi bawaan (biar Prettier yang atur)
    "linebreak-style": 0, // Matikan error CRLF (Windows)
    "require-jsdoc": 0, // Matikan kewajiban nulis komentar/dokumentasi
    "valid-jsdoc": 0, // Matikan validasi komentar
    "object-curly-spacing": 0,
    "max-len": 0, // Matikan batas panjang baris
    "@typescript-eslint/no-explicit-any": "off", // Bolehkan pakai 'any' (opsional)
  },
};
