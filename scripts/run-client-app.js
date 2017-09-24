const path = require("path");
const childProcess = require("child_process");

var electronPath = path.join("packages", "client-app", "node_modules", ".bin", "electron");
var clientPath = path.join("packages", "client-app");
var args = process.argv;
args = args.slice(2);
args.unshift(clientPath);

command = electronPath;
for(var i = 0; i < args.length; i++) {
    command += " " + args[i];
}

childProcess.exec(command);