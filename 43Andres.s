/* 
1. Nombre del Programa: Calculadora Simple
2. Descripción del Programa: Este programa realiza operaciones matemáticas básicas como suma, resta, multiplicación y división. El usuario elige una operación y luego ingresa dos números. El programa muestra el resultado de la operación.
3. Ejemplo de Cálculo:
   - Si el usuario ingresa:
     - Operación: Suma
     - Números: 5 y 3
     - El resultado será: 5 + 3 = 8


# Función para realizar la suma
def sumar(a, b):
    return a + b

# Función para realizar la resta
def restar(a, b):
    return a - b

# Función para realizar la multiplicación
def multiplicar(a, b):
    return a * b

# Función para realizar la división
def dividir(a, b):
    if b != 0:
        return a / b
    else:
        return "Error: División por cero"

# Menú de operaciones
def menu():
    print("Seleccione la operación:")
    print("1. Suma")
    print("2. Resta")
    print("3. Multiplicación")
    print("4. División")
    print("5. Salir")

# Solicitar al usuario que elija una operación
while True:
    menu()
    operacion = input("Ingrese el número de la operación que desea realizar: ")

    if operacion == '5':
        print("Saliendo del programa.")
        break

    num1 = float(input("Ingrese el primer número: "))
    num2 = float(input("Ingrese el segundo número: "))

    if operacion == '1':
        print(f"{num1} + {num2} = {sumar(num1, num2)}")
    elif operacion == '2':
        print(f"{num1} - {num2} = {restar(num1, num2)}")
    elif operacion == '3':
        print(f"{num1} * {num2} = {multiplicar(num1, num2)}")
    elif operacion == '4':
        print(f"{num1} / {num2} = {dividir(num1, num2)}")
    else:
        print("Operación no válida. Intente nuevamente.")
*/

// Programa en ARM64 para una calculadora simple que realiza suma, resta, multiplicación y división
// El usuario ingresa dos números y elige una operación (suma, resta, multiplicación o división).

.global _start

.section .data
    prompt: .asciz "Seleccione la operación:\n1. Suma\n2. Resta\n3. Multiplicación\n4. División\n5. Salir\n"
    enter_number: .asciz "Ingrese un número: "
    result_message: .asciz "El resultado es: "
    error_message: .asciz "Error: División por cero\n"
    newline: .asciz "\n"

.section .bss
    num1: .skip 8
    num2: .skip 8
    operacion: .skip 4

.section .text
_start:
    // Mostrar menú
    ldr x0, =prompt
    bl print_string

menu_loop:
    // Solicitar operación
    ldr x0, =prompt
    bl print_string
    ldr x0, =operacion
    bl read_string

    // Si el usuario elige 5, salir
    ldr w0, [operacion]
    cmp w0, '5'
    beq exit_program

    // Solicitar primer número
    ldr x0, =enter_number
    bl print_string
    ldr x0, =num1
    bl read_number

    // Solicitar segundo número
    ldr x0, =enter_number
    bl print_string
    ldr x0, =num2
    bl read_number

    // Realizar la operación
    cmp w0, '1' // Suma
    beq do_sum
    cmp w0, '2' // Resta
    beq do_subtract
    cmp w0, '3' // Multiplicación
    beq do_multiply
    cmp w0, '4' // División
    beq do_divide

    b menu_loop

do_sum:
    ldr x1, [num1]
    ldr x2, [num2]
    add x0, x1, x2
    bl print_result
    b menu_loop

do_subtract:
    ldr x1, [num1]
    ldr x2, [num2]
    sub x0, x1, x2
    bl print_result
    b menu_loop

do_multiply:
    ldr x1, [num1]
    ldr x2, [num2]
    mul x0, x1, x2
    bl print_result
    b menu_loop

do_divide:
    ldr x1, [num1]
    ldr x2, [num2]
    cbz x2, divide_error // Comprobar división por cero
    sdiv x0, x1, x2
    bl print_result
    b menu_loop

divide_error:
    ldr x0, =error_message
    bl print_string
    b menu_loop

print_result:
    ldr x0, =result_message
    bl print_string
    bl print_number
    ldr x0, =newline
    bl print_string
    ret

print_string:
    mov x2, x1
    bl strlen
    mov x8, 64
    svc 0
    ret

print_number:
    mov x8, 64
    mov x0, 1
    ldr x2, =num1
    bl number_to_string
    svc 0
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

number_to_string:
    mov x3, 10
    mov x4, x2
    ldr x1, =num1
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

read_string:
    mov x8, 63
    svc 0
    ret

read_number:
    mov x8, 63
    svc 0
    ret

exit_program:
    mov x8, 93
    mov x0, 0
    svc 0

