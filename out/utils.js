'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const Constants = require("./constants");
const nls = require("vscode-nls");
const localize = nls.loadMessageBundle();
/**
 * Helper to log messages to the developer console if enabled
 * @param msg Message to log to the console
 */
function logDebug(msg) {
    let config = vscode.workspace.getConfiguration(Constants.extensionConfigSectionName);
    let logDebugInfo = config[Constants.configLogDebugInfo];
    if (logDebugInfo === true) {
        let currentTime = new Date().toLocaleTimeString();
        let outputMsg = '[' + currentTime + ']: ' + msg ? msg.toString() : '';
        console.log(outputMsg);
    }
}
exports.logDebug = logDebug;
//# sourceMappingURL=utils.js.map