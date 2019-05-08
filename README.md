# easy-sphinxsearch
Docker image for a full working sphinx search with MSSQL Odbc Drivers 

# Docker Volumes

## /opt/sphinx/data
This directory should contain sphinx data

## /opt/sphinx/log
This directory should contain sphinx logs

## /opt/sphinx/conf 

This directory must contain the sphinx.conf file. Don't forget to change indexes data directories to /opt/sphinx/data and logs to /opt/sphinx/log. Listen port should be set to 9312. (see sphinx configuration here : http://sphinxsearch.com/docs/manual-2.3.2.html)

## /opt/odbc  

This directory must contain odbc.ini and odbcinst.ini.
odbc.ini describes data sources. Example :

 ```
[mydatabase]
DRIVER=ODBC Driver 17 for SQL Server  
DATABASE=mydatabase
SERVER= mydatabase.server.net
DESCRIPTION=mydatabase

```

Note that DRIVER=... should be equal to your odbc driver definition located in odbcinst.ini :
```
[nextinpact]
[ODBC Driver 17 for SQL Server] 
Description=Microsoft ODBC Driver 17 for SQL Server
Driver=/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.3.so.1.1
UsageCount=1
```

## /opt/cron
This directory can contain a crontab file that will be automatically installed at startup. Useful for running indexer cron jobs.
