'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const sqlops = require("sqlops");
const openurl = require("openurl");
const Utils = require("../utils");
// The main controller class that initializes the extension
class MainController {
    constructor(context) {
        this.context = context;
    }
    dispose() {
        this.deactivate();
    }
    deactivate() {
        Utils.logDebug('Main controller for IDERA SQL DM Performance Insights deactivated');
    }
    activate() {
        sqlops.tasks.registerTask('idera.product.resources', () => this.openTargetUrl('http://www.idera.com/UIFiles/tabs/sqldmperformanceinsights-resources.html'));
        sqlops.tasks.registerTask('idera.help', () => this.openTargetUrl('http://community.idera.com/free-tool-forums/f/idera-sql-dm-performance-insights'));
        Utils.logDebug('Main controller for IDERA SQL DM Performance Insights activated');
        return Promise.resolve(true);
    }
    openTargetUrl(link) {
        openurl.open(link);
    }
}
exports.default = MainController;
//# sourceMappingURL=mainController.js.map