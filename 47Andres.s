/* 
1. Nombre del Programa: Detección de Desbordamiento en Suma
2. Descripción del Programa: Este programa verifica si ocurre un desbordamiento al sumar dos números enteros. Si la suma excede el rango de números representables, se detecta como un desbordamiento.
3. Ejemplo de Cálculo:
   - Si se suman 2 números grandes como 2147483647 (máximo valor de un entero de 32 bits) + 1, el resultado es un desbordamiento.


# Función para detectar desbordamiento en la suma
def detectar_desbordamiento(a, b):
    try:
        resultado = a + b
        # Definir el rango para enteros de 32 bits
        INT32_MIN = -2**31
        INT32_MAX = 2**31 - 1
        
        if resultado < INT32_MIN or resultado > INT32_MAX:
            return True  # Desbordamiento detectado
        else:
            return False  # No hay desbordamiento
    except OverflowError:
        return True  # Desbordamiento detectado

# Solicitar los dos números al usuario
a = int(input("Ingrese el primer número: "))
b = int(input("Ingrese el segundo número: "))

# Verificar si hay desbordamiento
if detectar_desbordamiento(a, b):
    print("¡Desbordamiento detectado!")
else:
    print(f"La suma de {a} y {b} es: {a + b}")

*/ 

// Programa en ARM64 para detectar desbordamiento en la suma
// El programa suma dos números e imprime el resultado o detecta si ocurre un desbordamiento

.global _start

.section .data
    prompt_a: .asciz "Ingrese el primer número: "
    prompt_b: .asciz "Ingrese el segundo número: "
    overflow_msg: .asciz "¡Desbordamiento detectado!\n"
    result_msg: .asciz "La suma es: "
    newline: .asciz "\n"

.section .bss
    a: .skip 8
    b: .skip 8
    resultado: .skip 8

.section .text
_start:
    // Solicitar el primer número
    ldr x0, =prompt_a
    bl print_string
    ldr x0, =a
    bl read_number

    // Solicitar el segundo número
    ldr x0, =prompt_b
    bl print_string
    ldr x0, =b
    bl read_number

    // Cargar los valores de a y b
    ldr x0, =a
    ldr x1, =b
    ldr x2, [x0]
    ldr x3, [x1]

    // Realizar la suma y verificar el desbordamiento
    add x4, x2, x3
    cmp x4, x2
    bhi desbordamiento_detectado  // Si el resultado es menor que uno de los operandos, hay desbordamiento

    // No hay desbordamiento, mostrar la suma
    ldr x0, =result_msg
    bl print_string
    bl print_number
    b exit_program

desbordamiento_detectado:
    // Imprimir mensaje de desbordamiento
    ldr x0, =overflow_msg
    bl print_string

exit_program:
    mov x8, 93
    mov x0, 0
    svc 0

print_string:
    mov x2, x1
    bl strlen
    mov x8, 64
    svc 0
    ret

print_number:
    mov x8, 64
    mov x0, 1
    ldr x2, =a
    bl number_to_string
    svc 0
    ret

number_to_string:
    mov x3, 10
    mov x4, x2
    ldr x1, =a
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

