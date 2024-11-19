/* 
1. Nombre del Programa: Verificar si un Número es Armstrong
2. Descripción del Programa: Este programa verifica si un número dado es un número de Armstrong. Un número de Armstrong es aquel que es igual a la suma de sus dígitos elevados a la potencia de la cantidad de dígitos.
3. Ejemplo de Cálculo:
   - Si el número ingresado es 153:
     - 153 tiene 3 dígitos.
     - 1^3 + 5^3 + 3^3 = 1 + 125 + 27 = 153, que es un número de Armstrong.


# Función para verificar si el número es Armstrong
def es_armstrong(numero):
    num_str = str(numero)
    num_digitos = len(num_str)
    suma = sum(int(digit) ** num_digitos for digit in num_str)
    return suma == numero

# Solicitar un número al usuario
numero = int(input("Ingrese un número para verificar si es Armstrong: "))

# Verificar si es Armstrong y mostrar el resultado
if es_armstrong(numero):
    print(f"{numero} es un número de Armstrong.")
else:
    print(f"{numero} no es un número de Armstrong.")

*/ 

// Programa en ARM64 para verificar si un número es Armstrong
// El programa toma un número, verifica si es un número de Armstrong y muestra el resultado.

.global _start

.section .data
    prompt: .asciz "Ingrese un número para verificar si es Armstrong: "
    result_armstrong: .asciz " es un número de Armstrong.\n"
    result_not_armstrong: .asciz " no es un número de Armstrong.\n"
    newline: .asciz "\n"

.section .bss
    numero: .skip 8
    suma: .skip 8

.section .text
_start:
    // Solicitar el número
    ldr x0, =prompt
    bl print_string
    ldr x0, =numero
    bl read_number

    // Verificar si el número es Armstrong
    ldr x0, [numero]
    bl check_armstrong

    // Mostrar el resultado
    ldr x0, [numero]
    bl print_number
    ldr x0, =result_armstrong
    bl print_string
    b exit_program

check_armstrong:
    // Función para verificar si el número es Armstrong
    mov x1, x0               // Guardamos el número en x1
    mov x2, 0                 // Inicializamos la suma en 0
    mov x3, 10                // Constante para dividir por 10 (extraer dígitos)

    // Calcular la cantidad de dígitos
    mov x4, 0                 // Inicializamos la cantidad de dígitos en 0
count_digits:
    udiv x5, x1, x3           // Dividimos el número por 10
    mul x6, x5, x3            // Multiplicamos para recuperar la última cifra
    sub x1, x1, x6            // Restamos la última cifra del número
    add x4, x4, 1             // Incrementamos la cantidad de dígitos
    cmp x1, 0
    bne count_digits          // Continuamos mientras el número no sea 0

    mov x1, [numero]          // Restauramos el número original
    mov x2, 0                 // Inicializamos la suma en 0

    // Verificar si es un número de Armstrong
check_armstrong_loop:
    udiv x5, x1, x3           // Dividimos el número por 10
    mul x6, x5, x3            // Multiplicamos para recuperar la última cifra
    sub x1, x1, x6            // Restamos la última cifra del número
    mov x7, x6                // Guardamos la última cifra en x7
    mov x8, 0                 // Inicializamos la suma de las potencias en 0
    mov x9, x7                // Inicializamos la base de la potencia

    // Potenciar la cifra por la cantidad de dígitos
power_loop:
    mul x8, x8, x9            // Multiplicamos la cifra por sí misma
    sub x4, x4, 1             // Reducimos el contador de dígitos
    cmp x4, 0
    bne power_loop            // Continuamos mientras queden dígitos

    add x2, x2, x8            // Sumamos el valor al total

    cmp x2, [numero]          // Comparamos la suma con el número original
    beq armstrong_true        // Si son iguales, es Armstrong

    b check_armstrong_loop

armstrong_true:
    ldr x0, =result_armstrong
    bl print_string
    b exit_program

print_string:
    mov x2, x1
    bl strlen
    mov x8, 64
    svc 0
    ret

print_number:
    mov x8, 64
    mov x0, 1
    ldr x2, =numero
    bl number_to_string
    svc 0
    ret

number_to_string:
    mov x3, 10
    mov x4, x2
    ldr x1, =numero
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

read_number:
    mov x8, 63
    svc 0
    ret

exit_program:
    mov x8, 93
    mov x0, 0
    svc 0

