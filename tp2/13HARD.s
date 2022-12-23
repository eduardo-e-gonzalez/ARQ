Modificar el programa anterior para que también cuente minutos (00:00 - 59:59), pero que actualice la visualización en
pantalla cada 10 segundos.
;ultimo compilado
;13

CONT EQU 10H ;CONTADOR DEL TIMER }
COMP EQU 11H ;CUANDO VA A CORTAR } ESTOS 2 SON DEL TIMER

EOI EQU 20H
IMR EQU 21H  ;imr: que interrupcion voy a escuchar
IRR EQU 22H
ISR EQU 23H      
INT0 EQU 24H
INT1 EQU 25H     ;ESTAS SON "TODAS LAS CONSTANTES"
INT2 EQU 26H    ; UNA VEZ Q LO TENGAS CLARO DECLARAR SOLO LAS Q VAS A USAR
INT3 EQU 27H


ORG 1000H
;CONFIGURO LOS DATOS QUE VOY A USAR PARA LA INTERRUPCION
MINUTOS DB 30H
        DB 30H  ;ME GUARDO 2 LUGARES EN 0
SEGUNDOS DB 30H
         DB 30H ;ME GUARDO 2 LUGARES EN 0
SALTO DB 0AH
FIN DB ?

ORG 40                     ;10X4= 40
 DIREC_SUBRUTINA DW 3000H  ;ACA LE INDICO DONDE ESTA MI SUBRUTINA A EJECUTAR
 
 
ORG 3000H
 CONFIG_RELOG: PUSH AX     ;CREO UN RESPALDO DE AX PARA SALVARLO
 
 ;VAMOS SUMANDO DEL 00 AL 09
 MOV BX, OFFSET SEGUNDOS
 INC BX                    ;APUNTA AL SEGUNDO DIGITO DE SEGUNDOS
 ADD BYTE PTR [BX],10      ;EN LA POSICION/DIRECCION DEEL SEGUNDO DIGITO, PONE EL 10 
 CMP BYTE PTR [BX], 3AH    ;HACE ESTO VA VER SI SE SALIO DEL RANGO 1...9/ 3AH= : ES EL SIGUIENTE AL 9
 JNZ RESET                 ;si llega al final salto a reset 
 
 
 ;VAMOS SUMANDO DEL 00 AL 60 (En la direccion que le sigue a segundo)
 ;COMIENZO EN EL SEGUNDO DIGITO
 MOV BYTE PTR [BX], 30H ;iniciamos en 0
 DEC BX ;SEG
 INC BYTE PTR [BX]                                          ;PRE CONFIG DE LOS SEGUNDOS
 CMP BYTE PTR [BX], 39H ;Hasta el 60
 JNZ RESET
 
 
 MOV BYTE PTR [BX], 30H ;iniciamos en 0
 DEC BX ;MINUTOS
 INC BYTE PTR [BX]                                           ;CONTROLO LOS SEGUNDOS
 CMP BYTE PTR [BX], 36H ;Hasta el 60
 JNZ RESET
 
 MOV BYTE PTR [BX], 30H ;iniciamos en 0
 DEC BX ;MINUTOS
 INC BYTE PTR [BX]                                       ;AUMENTO EL DIGITO DE LOS MINUTOSS
 CMP BYTE PTR [BX], 36H ;Hasta el 60
 JNZ RESET
 
 
 MOV BYTE PTR [BX], 30H
 
 RESET: MOV BX, OFFSET MINUTOS ;REINICIAMOS EL ESTADO DE SEGUNDOS
 MOV AL, OFFSET FIN-OFFSET MINUTOS ;PORQUE LO USAMOS MAS ARRIBA
 INT 7
 MOV AL, 0
 OUT 10H, AL
 MOV AL, 20H
 OUT 20H, AL
 POP AX
IRET

ORG 2000H
; ID 10 PARA EL TIMER
;CONFIGURAR EL VECTOR DE INTERRUPCIONES

;CONFIGURARCION DEL PIC

CLI  ; INHABILITO LAS INTERRUPCIONES

MOV AL, 0FDH ; 1111 1101 AVISO QUE VOY A ESCUCHAR SOLO AL TIMER
OUT IMR, AL  ; ESCRIBI EN EL IMR, QUE VAMOS A ATENDER AL TIMER

;CONFIGURO EL INDICE
;CONFIGURO EL CONTADOR DEL PIC /; OSEA EL TIMER 
MOV AL, 10   ;ID 10 / ;10 X 4 = 40
OUT INT1, AL ;21H = IMR = IMR TIMER ID

MOV AL, 10   ;PONGO EN MI COMPARADOR CADA CUANTOS SEGUNDOS VA IMPRIMIR/ EN ESTE CASO CADA 10
OUT COMP, AL ;COMP 11H

MOV AL, 0    ;INICIALIZO MI CONTADOR EN 0
OUT CONT, AL ;CONT 10H

STI  ;HABILITO LAS INTERRUPCIONES
LAZO: JMP LAZO

INT 0
END