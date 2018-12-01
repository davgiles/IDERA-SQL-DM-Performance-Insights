// Copyright © 2018 IDERA, Inc. All rights reserved.
'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const mainController_1 = require("./controllers/mainController");
let mainController;
// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
function activate(context) {
    let activations = [];
    // Start the main controller
    mainController = new mainController_1.default(context);
    context.subscriptions.push(mainController);
    activations.push(mainController.activate());
    return Promise.all(activations)
        .then((results) => {
        for (let result of results) {
            if (!result) {
                return false;
            }
        }
        return true;
    });
}
exports.activate = activate;
function deactivate() {
    if (mainController) {
        mainController.deactivate();
    }
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map