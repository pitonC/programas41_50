/* 
1. Nombre del Programa: Generación de Números Aleatorios con Semilla
2. Descripción del Programa: Este programa genera números aleatorios utilizando una semilla proporcionada por el usuario. La semilla asegura que la secuencia de números aleatorios sea reproducible.
3. Ejemplo de Cálculo:
   - Si el usuario ingresa la semilla 42, el programa generará una secuencia de números aleatorios basada en esa semilla.


import random

# Solicitar la semilla al usuario
semilla = int(input("Ingrese la semilla para generar números aleatorios: "))

# Establecer la semilla
random.seed(semilla)

# Generar y mostrar 5 números aleatorios
print("Generando 5 números aleatorios:")
for _ in range(5):
    print(random.randint(1, 100))

*/ 
// Programa en ARM64 para generar números aleatorios con semilla
// El usuario proporciona una semilla, y el programa genera números aleatorios basados en esa semilla.

.global _start

.section .data
    prompt: .asciz "Ingrese la semilla para generar números aleatorios: "
    result_message: .asciz "Número aleatorio generado: "
    newline: .asciz "\n"

.section .bss
    semilla: .skip 8
    random_number: .skip 4

.section .text
_start:
    // Solicitar la semilla
    ldr x0, =prompt
    bl print_string
    ldr x0, =semilla
    bl read_number

    // Establecer la semilla
    ldr x0, [semilla]
    bl set_seed

    // Generar y mostrar 5 números aleatorios
    mov x0, 5
generate_loop:
    bl generate_random_number
    ldr x0, =result_message
    bl print_string
    ldr x0, [random_number]
    bl print_number
    ldr x0, =newline
    bl print_string
    sub x0, x0, 1
    cmp x0, 0
    bgt generate_loop

    // Salir
    mov x8, 93             // syscall para exit
    mov x0, 0              // código de salida
    svc 0

// Función para generar un número aleatorio basado en la semilla
generate_random_number:
    ldr x0, [semilla]
    mul x0, x0, 1664525   // Constante multiplicativa (Mersenne-Twister)
    add x0, x0, 1013904223 // Constante aditiva
    and x0, x0, 0xFFFFFFFF // Asegurar que el número esté en 32 bits
    str x0, [random_number]
    ret

// Función para establecer la semilla
set_seed:
    // La semilla es el valor de entrada proporcionado por el usuario
    ret

// Función para imprimir una cadena
print_string:
    mov x2, x1
    bl strlen
    mov x8, 64
    svc 0
    ret

// Función para imprimir un número
print_number:
    mov x8, 64
    mov x0, 1
    ldr x2, =random_number
    bl number_to_string
    svc 0
    ret

// Función para convertir número a cadena
number_to_string:
    mov x3, 10
    mov x4, x2
    ldr x1, =random_number
    add x1, x1, 16
    mov byte [x1], 0

num_to_str_loop:
    sub x1, x1, 1
    udiv x5, x4, x3
    msub x6, x5, x3, x4
    add x6, x6, '0'
    strb w6, [x1]
    mov x4, x5
    cmp x4, 0
    bne num_to_str_loop
    ret

// Función para obtener la longitud de una cadena
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

// Función para leer un número
read_number:
    mov x8, 63
    svc 0
    ret
