// Checks for Node.js 20 or later, then runs a BuildKeel component in this same
// process. Started by bk-launch, so each start costs one Node process, not two.
// Usage: node bk-start.cjs <component entry> [args...]
// Kept to old syntax so an old Node can still read it and say what is needed.
"use strict";

var REQUIRED_MAJOR = 20;

var version = process.versions.node;
var major = Number(version.split(".")[0]);
if (!(major >= REQUIRED_MAJOR)) {
  process.stderr.write(
    "BuildKeel needs Node.js " + REQUIRED_MAJOR + " or later. Found Node.js " + version + ".\n" +
      'Install it from https://nodejs.org or with your version manager (for example "nvm install ' + REQUIRED_MAJOR + '"), then start a new session.\n',
  );
  process.exit(1);
}

var entry = process.argv[2];
// The component reads its own arguments from process.argv.slice(2), as if Node had started it directly.
process.argv.splice(1, 2, entry);
import(require("node:url").pathToFileURL(entry).href).catch(function (error) {
  process.stderr.write("BuildKeel could not start " + entry + ": " + (error && error.message ? error.message : String(error)) + "\n");
  process.exit(1);
});
