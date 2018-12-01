# IDERA SQL DM Performance Insights in Azure Data Studio

IDERA SQL DM Performance Insights is a free extension for Azure Data Studio that quickly allows you to see high level common performance issues in multi-server dashboard widgets using an IDERA SQL Diagnostic Manager repository.

**`To review the IDERA Free Tools EULA, please click`** [here](https://d7umqicpi7263.cloudfront.net/eula/product/2f850185-a21a-4b72-a75e-5dca4f70cede/22d44622-66c1-4074-8aae-7fd41d987496.txt).

This preview provides the following features:
- **Servers:** display metrics such as CPU, Disk I/O, Network and Memory Used
- **Sessions:** display session summary averages such as Client Connections, Logins, User Processes, Transactions and Oldest Open Transactions
- **Databases:** display database summary related statistics such as Reads, Writes, Transactions, Log activity
- **Queries:** display Wait Statistics and summaries of Query Statistics

### Prerequisites
- Azure Data Studio 1.1.3+ with Preview Features enabled
- IDERA SQL Diagnostic Manager 10.3+ Repository on SQL Server 2012+, click [here](https://www.idera.com/productssolutions/sqlserver/sqldiagnosticmanager) to get a fully-functioning, 14-day, free trial.
- IDERA SQL Diagnostic Manager database repository must be named 'SQLdmRepository'

### Install Extension
- Open Azure Data Studio
- Go to `File` then `Install Extension from VSIX Package`

### Use Extension
- Add a new connection for a server that has an IDERA SQL DM repository database named "SQLdmRepository"
- Select the server to connect and wait until the icon is green
- Right-click the server connection and select `Manage`
- In the right-hand dashboard, select the tab labeled **IDERA SQL DM PERFORMANCE INSIGHTS**
- Select any navigation tab in the navigation bar under **HOME** to start using the features

### Report an Issue
Select the `Help` tab in the navigation bar and click `IDERA Community Support` in the IDERA Resources task widget.

### More on IDERA
To learn more about IDERA, please visit [our website](http://www.idera.com).
