#include "sqlrdd.ch"

request SR_ODBC
//request SQLRDD

function main() 

   ?"cheguei aqui"

   ? SR_AddConnection( 1, "dsn=SQL Server1")
   inkey(3)

return