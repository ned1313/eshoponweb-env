sqlcmd -i CreateDB.sql -S tcp:SERVER_NAME,1433 -U USERNAME -P PASSWORD
sqlcmd -d CatalogDB -i InitialCreate.sql -S tcp:SERVER_NAME,1433 -U USERNAME -P PASSWORD
sqlcmd -d IdentityDB -i InitialCreateAppID.sql -S tcp:SERVER_NAME,1433 -U USERNAME -P PASSWORD
