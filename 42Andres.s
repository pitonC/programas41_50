/* 
1. Nombre del Programa: Conversión de Hexadecimal a Decimal
2. Descripción del Programa: Este programa convierte un número hexadecimal proporcionado por el usuario a su equivalente en decimal.
3. Ejemplo de Cálculo:
   - Si el usuario ingresa '1A3', el programa calculará:
     - 1A3 (hex) = 1*(16^2) + 10*(16^1) + 3*(16^0) = 1*256 + 10*16 + 3 = 419 (decimal)


# Función para convertir hexadecimal a decimal
def hexadecimal_a_decimal(hex_str):
    return int(hex_str, 16)

# Solicitar al usuario que ingrese un número hexadecimal
hexadecimal = input("Ingrese un número hexadecimal: ")

# Convertir el número hexadecimal a decimal
decimal = hexadecimal_a_decimal(hexadecimal)

# Mostrar el resultado
print(f"El valor decimal de {hexadecimal} es: {decimal}")

*/ 
// Programa en ARM64 para convertir un valor hexadecimal a decimal
// La entrada será un valor hexadecimal y la salida será su equivalente en decimal

.global _start

.section .data
    prompt: .asciz "Ingrese un número hexadecimal: "
    result_message: .asciz "El valor decimal es: "
    newline: .asciz "\n"

.section .bss
    input: .skip 16        // Reservar espacio para la entrada

.section .text
_start:
    // Imprimir mensaje de solicitud de entrada
    mov x0, 1              // Descritor de archivo para stdout
    ldr x1, =prompt        // Dirección del mensaje
    bl print_string

    // Leer entrada del usuario
    mov x0, 0              // Descritor de archivo para stdin
    ldr x1, =input         // Dirección de memoria donde se guardará la entrada
    mov x2, 16             // Leer hasta 16 caracteres
    bl read_string

    // Convertir la cadena hexadecimal a número decimal
    ldr x0, =input         // Dirección de la entrada hexadecimal
    bl hex_to_decimal

    // Imprimir el resultado
    mov x0, 1              // Descritor de archivo para stdout
    ldr x1, =result_message // Dirección del mensaje
    bl print_string

    // Imprimir el número decimal
    mov x0, x1             // Número decimal en x1
    bl print_number

    // Nueva línea
    ldr x0, =newline       // Dirección de la nueva línea
    bl print_string

    // Salir del programa
    mov x8, 93             // syscall número para exit
    mov x0, 0              // Código de salida
    svc 0

// Función para imprimir una cadena
print_string:
    mov x2, x1             // Longitud de la cadena
    bl strlen
    mov x8, 64             // syscall número para write
    svc 0
    ret

// Función para leer una cadena
read_string:
    mov x8, 63             // syscall número para read
    svc 0
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

// Función para convertir hexadecimal a decimal
hex_to_decimal:
    mov x2, 0              // Resultado (inicialmente 0)
    mov x3, 16             // Base hexadecimal

hex_loop:
    ldrb w4, [x0], 1       // Leer un carácter de la entrada
    cmp w4, 10
    blt hex_digit          // Si es menor que 10, es un dígito
    add w4, w4, -'A' + 10   // Si es una letra, convertir a valor numérico
    b hex_process

hex_digit:
    sub w4, w4, '0'        // Convertir el dígito a valor numérico

hex_process:
    mul x2, x2, x3         // Multiplicar el resultado por 16
    add x2, x2, x4         // Sumar el valor del dígito
    cmp w4, 0
    bne hex_loop
    mov x1, x2             // Guardar el resultado en x1
    ret

// Función para imprimir un número decimal
print_number:
    mov x8, 64             // syscall número para write
    mov x0, 1              // Descritor de archivo para stdout
    ldr x2, =buffer        // Dirección del buffer
    bl number_to_string    // Convertir número a cadena
    svc 0
    ret

// Función para convertir un número decimal a cadena
number_to_string:
    mov x3, 10             // Base 10
    mov x4, x2             // Número a convertir
    ldr x1, =buffer        // Dirección de buffer
    add x1, x1, 16         // Apuntar al final del buffer
    mov byte [x1], 0       // Colocar el terminador de cadena

num_to_str_loop:
    sub x1, x1, 1
    udiv x5, x4, x3        // Dividir el número entre 10
    msub x6, x5, x3, x4    // Resto de la división
    add x6, x6, '0'        // Convertir a carácter
    strb w6, [x1]          // Guardar carácter en el buffer
    mov x4, x5             // Actualizar número
    cmp x4, 0
    bne num_to_str_loop
    ret

.section .bss
buffer: .skip 20         // Espacio para almacenar la cadena del número

