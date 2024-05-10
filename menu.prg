#include "sqlrdd.ch"

function Menu
public nValor := 0
public nSaldo := 0
public cUse 
public cCreate
public pCode
public usecode

//request HB_codepage_utf8
request SR_ODBC
request SQLRDD 

SET DATE BRITISH
SET CENT ON

SET DELIMITERS ON
SET DELIMITERS TO "[]"
SET COLOR TO "G/W, W+/G+"
   //hb_cdpSelect("UTF8")
   dbstart()
   cls
   connect()
   inkey(2)

   cUse := "USE HARBOUR"
   cSql := "select * from aluno"
   
   
   usecode := SR_SQLParse(cUse)  
   
   pCode := SR_SQLParse(cSql)
   
   ?SR_SQLCodeGen(usecode)
   ?"acessou o banco"
   inkey(4)

   ?SR_SQLCodeGen(pCode)
   ?"fez o select"
   inkey(4)

   DO WHILE .T.
      CLS
      @ 2, 1 SAY "Conta Corrente V2"
      @ 2, 30 SAY DATE()

      @ 4 , 5 TO 10 , 40 DOUBLE // Crio um box com @ ... TO

      @ 5 ,20 PROMPT " Depósito " MESSAGE "Realizar um depósito na Conta corrente"
      @ 6 ,20 PROMPT " Saque " MESSAGE "Realizar um saque na Conta corrente"
      @ 7 ,20 PROMPT " Sair " MESSAGE "Encerra o programa "

      @ 9, 8 SAY "Saldo: " + transform(saldo, "@E 999,999.99")
      SET MESSAGE TO 11 // aqui esta setando para imprimir as mensagens na linha 9

      // Aqui eu seleciono a opcao
      MENU TO nOpcao

      // Aqui eu analiso o valor de nOpcao
      DO CASE
      CASE nOpcao == 1
         CLS
         @ 1, 1 SAY "Conta Corrente v1"
         @ 1, 22 SAY DATE()

         @ 4 , 5 TO 9 , 40 DOUBLE // Crio um box com @ ... TO

         nValor := 0

         @ 6 , 6 SAY "Informe o valor" GET nValor PICTURE "@E 999,999.99"
         READ
         if nValor > 0 
            CalculaDeposito()            
            replace Saldo with nSaldo
         else
            @ 11, 0 SAY "Digite um valor maior que zero para o deposito!"
            inkey(3)
            
         endif 

   ///////////////////////////////      
      CASE nOpcao == 2
         CLS
         @ 1, 1 SAY "Conta Corrente v1"
         @ 1, 22 SAY DATE()

         @ 4 , 5 TO 9 , 40 DOUBLE // Crio um box com @ ... TO

         nValor := 0

         @ 6 , 6 SAY "Informe o valor" GET nValor PICTURE "@E 999,999.99"
         READ

          if nValor > 0            
            CalculaSaque()
            replace Saldo with nSaldo                       
         else
            @ 11, 0 SAY "Digite um valor maior que zero para o saque!"
            inkey(3)
            
         endif 
   ///////////////////////////////   
      CASE nOpcao == 3 
         CLS
         QUIT   
      ENDCASE
   ENDDO

return

///////////////////////////////

function CalculaDeposito()
return nSaldo := nSaldo + nValor

///////////////////////////////

function CalculaSaque()
return nSaldo := nSaldo - nValor

///////////////////////////////

function dbstart

   LOCAL aStruct := {{"Saldo", "N", 15, 2}} 
   
   IF .NOT. file ("conta.dbf")
   dbcreate("conta" , aStruct)
   ENDIF
   
   USE conta
   APPEND BLANK
   
return nil

function connect
   ? "add", SR_AddConnection( 1, "dsn=SQL Server1")
   ? "getative", SR_GetActiveConnection()
   ? "getconnectio", SR_GetConnection(1)

return