/* 
1. Nombre del Programa: Medir el Tiempo de Ejecución de una Función
2. Descripción del Programa: Este programa mide el tiempo de ejecución de una función específica utilizando la biblioteca `time`. La función que se mide realiza un cálculo sencillo (por ejemplo, una suma en bucle).
3. Ejemplo de Cálculo:
   - La función `calcular_suma` realiza una suma en bucle. Al medir su tiempo de ejecución, se obtiene el tiempo en segundos que toma completar la operación.


import time

# Función para medir el tiempo de ejecución
def medir_tiempo(func):
    start_time = time.time()  # Obtener el tiempo de inicio
    func()  # Llamar a la función
    end_time = time.time()  # Obtener el tiempo de fin
    return end_time - start_time  # Calcular la diferencia

# Función ejemplo: calcular suma de números
def calcular_suma():
    total = 0
    for i in range(1000000):
        total += i
    print(f"La suma es: {total}")

# Medir el tiempo de ejecución de la función calcular_suma
tiempo = medir_tiempo(calcular_suma)

# Imprimir el tiempo de ejecución
print(f"El tiempo de ejecución de la función es: {tiempo} segundos.")

*/ 

// Programa en ARM64 para medir el tiempo de ejecución de una función
// El programa mide el tiempo que toma ejecutar una función que realiza un cálculo simple (por ejemplo, una suma en bucle).

.global _start

.section .data
    result_msg: .asciz "La suma es: "
    time_msg: .asciz "El tiempo de ejecución de la función es: "
    newline: .asciz "\n"

.section .bss
    total: .skip 8
    start_time: .skip 8
    end_time: .skip 8
    tiempo_ejecucion: .skip 8

.section .text
_start:
    // Obtener el tiempo de inicio
    bl get_time
    str x0, [start_time]  // Guardar el tiempo de inicio

    // Llamar a la función calcular_suma
    bl calcular_suma

    // Obtener el tiempo de fin
    bl get_time
    str x0, [end_time]  // Guardar el tiempo de fin

    // Calcular el tiempo de ejecución
    ldr x0, [end_time]
    ldr x1, [start_time]
    sub x0, x0, x1  // x0 = end_time - start_time
    str x0, [tiempo_ejecucion]  // Guardar el tiempo de ejecución

    // Mostrar el resultado
    ldr x0, =time_msg
    bl print_string
    ldr x0, [tiempo_ejecucion]
    bl print_number
    ldr x0, =newline
    bl print_string

    // Terminar el programa
    mov x8, 93
    mov x0, 0
    svc 0

// Función calcular_suma: calcula la suma de los números
calcular_suma:
    mov x1, 0          // total = 0
    mov x2, 1000000    // Limite de la suma
calcular_suma_loop:
    add x1, x1, x2     // total += x2
    subs x2, x2, 1     // x2 -= 1
    bne calcular_suma_loop
    ldr x0, =result_msg
    bl print_string
    mov x0, x1
    bl print_number
    ret

// Función para obtener el tiempo actual (en segundos)
get_time:
    mov x8, 169         // Número de servicio para obtener el tiempo
    svc 0
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
    ldr x2, =total
    bl number_to_string
    svc 0
    ret

// Función para convertir número a cadena
number_to_string:
    mov x3, 10
    mov x4, x2
    ldr x1, =total
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

