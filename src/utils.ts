'use strict';

import * as vscode from 'vscode';
import * as Constants from './constants';
import * as nls from 'vscode-nls';

const localize = nls.loadMessageBundle();

/**
 * Helper to log messages to the developer console if enabled
 * @param msg Message to log to the console
 */
export function logDebug(msg: any): void {
	let config = vscode.workspace.getConfiguration(Constants.extensionConfigSectionName);
	let logDebugInfo = config[Constants.configLogDebugInfo];
	if (logDebugInfo === true) {
		let currentTime = new Date().toLocaleTimeString();
		let outputMsg = '[' + currentTime + ']: ' + msg ? msg.toString() : '';
		console.log(outputMsg);
	}
}

