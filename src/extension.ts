// Copyright © 2018 IDERA, Inc. All rights reserved.

'use strict';

// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import MainController from './controllers/mainController';

let mainController: MainController;

// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext): Promise<boolean> {
	let activations: Promise<boolean>[] = [];

	// Start the main controller
	mainController = new MainController(context);
	context.subscriptions.push(mainController);
	activations.push(mainController.activate());

	return Promise.all(activations)
		.then((results: boolean[]) => {
			for (let result of results) {
				if (!result) {
					return false;
				}
			}
			return true;
		});

}

export function deactivate() {
    if (mainController) {
		mainController.deactivate();
	}
}

