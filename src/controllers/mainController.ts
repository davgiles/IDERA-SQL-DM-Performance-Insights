'use strict';

import * as sqlops from 'sqlops';
import * as vscode from 'vscode';
import * as openurl from 'openurl';
import * as Utils from '../utils';

// The main controller class that initializes the extension
export default class MainController implements vscode.Disposable {
	constructor(protected context: vscode.ExtensionContext) {
	}

	public dispose(): void {
		this.deactivate();
	}

	public deactivate(): void {
		Utils.logDebug('Main controller for IDERA SQL DM Performance Insights deactivated');
	}

	public activate(): Promise<boolean> {
        sqlops.tasks.registerTask('idera.product.resources', () => this.openTargetUrl('http://www.idera.com/UIFiles/tabs/sqldmperformanceinsights-resources.html'));
        sqlops.tasks.registerTask('idera.help', () => this.openTargetUrl('http://community.idera.com/free-tool-forums/f/idera-sql-dm-performance-insights'));
		
		Utils.logDebug('Main controller for IDERA SQL DM Performance Insights activated');
		
		return Promise.resolve(true);
    }

    private openTargetUrl(link: string): void {
        openurl.open(link);
	}
	
	// private async testSQLdmDatabase(): Promise<void> {
	//     const currentConnection = await sqlops.connection.getCurrentConnection();
	//     const connectionId = currentConnection.connectionId;
	//     const database = 'SQLdmRepository';

	//     const nodes = await sqlops.objectexplorer.findNodes(connectionId, 'Database', undefined, database, undefined, undefined);
	//     if (nodes)  {
	//     } else {
	//         vscode.window.showInformationMessage("This extension is designed to use a database named 'SQLdmRepository' installed by IDERA's SQL Diagnostic Manager." +
	//             "Add or select another connection that contains this database.");
	//     }
	// }
}