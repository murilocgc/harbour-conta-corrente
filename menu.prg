#include "sqlrdd.ch"
#include "dbinfo.ch"

request SR_ODBC
request SQLRDD
****************************************************************************
Function Menu //é a função principal
****************************************************************************
public nValor := 0
public nSaldo := 0
public  

SET DATE BRITISH
SET CENT ON

SET DELIMITERS ON
SET DELIMITERS TO "[]"
SET COLOR TO "G/W, W+/G+" 
   Begin Sequence
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
         
         CASE nOpcao == 3 
            CLS
            QUIT   
         ENDCASE
      ENDDO
   End Sequence

return


****************************************************************************
function CalculaDeposito()
****************************************************************************
return nSaldo := nSaldo + nValor


****************************************************************************
function CalculaSaque()
****************************************************************************
return nSaldo := nSaldo - nValor


****************************************************************************
function dbstart
****************************************************************************
   LOCAL aStruct := {{"Saldo", "N", 15, 2}} 
   
   IF .NOT. file ("conta.dbf")
   dbcreate("conta" , aStruct)
   ENDIF
   
   USE conta
   APPEND BLANK
   
return nil


****************************************************************************
Function Connect() // Função que realiza a conexão com o banco
**************************************************************************** 
   local nIdConnection   

   nIdConnection := SR_AddConnection( 1, "dsn=SQL Server1;DTB=HARBOUR" )
   //retorna o id da conexão 

Return nIdConnection


****************************************************************************
Function RetSql( cSql ) // Função que passa o comando SQL para o Banco
****************************************************************************   

   local oConnect    
   local aRetSql := {}   
   local nIdConnection

   nIdConnection := Connect() // obtém o id da conexão

   oConnect := SR_GetCnn( nIdConnection ) // obtém o objeto da conexão

   oConnect:Exec( cSql, , .T., @aRetSql )  
   //executa o método para o objeto, passando o comando sql para o banco.

Return aRetSql