Escribir un programa que efectúe la suma de dos números (de un dígito cada uno) ingresados por teclado y muestre el
resultado en la pantalla de comandos. Recordar que el código de cada caracter ingresado no coincide con el número que
representa y que el resultado puede necesitar ser expresado con 2 dígitos.

ORG 1000H
MENSAJ DB " Ingresa tus 2 numeros a sumar "
FINTABLA DB ?

MSJ_RESUL DB " EL RESULTADO DE LA SUMA ES: "
FIN DB ?

NUM1 DB ?
NUM2 DB ?
TOTALA DB "0" ; 0 o 1
TOTALB DB ? 
ORG 3000H


VALIDAR: MOV TOTALB, CL
MOV BX, OFFSET MSJ_RESUL
MOV AL, OFFSET FIN-OFFSET MSJ_RESUL
INT 7 ;EL RESULTADO DE LA SUMA ES:

MOV BX, OFFSET TOTALB  ;IMPRIMO DESDE TOTALA (1...9) ONLY
MOV AL, 1 ;CANT DE CARACTERES A IMPRIMIR ; CASO A 1 DIGITO
INT 7
RET


CONVERSOR: MOV CL, NUM1 ; COPIO NUM1
SUB CL, 30H
MOV DL, NUM2 ; COPIO NUM2
;SUB DL, 30H
ADD CL, DL
CMP CL, 3AH ; SI ESTOY EN EL RANGO DE 1 A 9 ESTA BIEN; 

JS VALIDAR
SUB CL, 10 ; SI ES MAYOR Q 9 ; RESTO10 (CL> 39H)
INC TOTALA

MOV TOTALB, CL

MOV BX, OFFSET MSJ_RESUL
MOV AL, OFFSET FIN-OFFSET MSJ_RESUL
INT 7 ;EL RESULTADO DE LA SUMA ES:

MOV BX, OFFSET TOTALA  ;IMPRIMO DESDE TOTALA (1...9) ONLY
MOV AL, 2 ;CASO B 2 DIGITOS
INT 7
RET

RET

PEDIRNUM: MOV BX, OFFSET NUM1 ;EN LA DIRECCION DE NUM1 GUARDO EL PRIMER NUMERO LEIDO
INT 6
MOV BX, OFFSET NUM2 ;EN LA DIRECCION DE NUM2 GUARDO EL SEGUNDO NUMERO LEIDO
INT 6

CALL CONVERSOR ; Aca voy a restar 30h = 0 a los 2, asi me queda el digito

RET

ORG 2000H
MOV BX, OFFSET MENSAJ
MOV AL, OFFSET FINTABLA-OFFSET MENSAJ
INT 7 ;INGRESAME UN NUMERO

CALL PEDIRNUM

INT 0
END