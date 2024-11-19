/* 
1. Nombre del Programa: Leer Entrada desde el Teclado
2. Descripción del Programa: Este programa lee una entrada del usuario desde el teclado. El programa solicita al usuario que ingrese un número y luego lo imprime.
3. Ejemplo de Cálculo:
   - El usuario ingresa el número `10`, y el programa muestra el número ingresado.


# Solicitar la entrada del usuario
entrada = input("Ingrese un número: ")

# Imprimir la entrada
print(f"Usted ingresó: {entrada}")

*/ 

// Programa en ARM64 para leer la entrada desde el teclado
// El programa solicita un número al usuario y lo imprime en pantalla

.global _start

.section .data
    prompt: .asciz "Ingrese un número: "
    result_msg: .asciz "Usted ingresó: "
    newline: .asciz "\n"

.section .bss
    entrada: .skip 8

.section .text
_start:
    // Solicitar entrada desde el teclado
    ldr x0, =prompt
    bl print_string

    ldr x0, =entrada
    mov x1, 10  // Limitar la longitud de entrada a 10 caracteres
    bl read_input

    // Imprimir el mensaje
    ldr x0, =result_msg
    bl print_string

    // Imprimir la entrada
    ldr x0, =entrada
    bl print_string

    // Salto de línea
    ldr x0, =newline
    bl print_string

    // Terminar el programa
    mov x8, 93
    mov x0, 0
    svc 0

// Función para leer la entrada desde el teclado
read_input:
    mov x8, 63  // Número de servicio para leer entrada
    svc 0
    ret

// Función para imprimir una cadena
print_string:
    mov x2, x1
    bl strlen
    mov x8, 64
    svc 0
    ret

// Función para obtener la longitud de la cadena
strlen:
    mov x2, 0
strlen_loop:
    ldrb w3, [x1, x2]
    cmp w3, 0
    beq strlen_done
    add x2, x2, 1
    b strlen_loop
strlen_done:
    ret
