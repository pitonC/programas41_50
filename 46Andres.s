/* 
1. Nombre del Programa: Encontrar Prefijo Común Más Largo
2. Descripción del Programa: Este programa recibe una lista de cadenas y encuentra el prefijo común más largo entre ellas. El prefijo común más largo es la secuencia de caracteres más larga que es compartida por todas las cadenas.
3. Ejemplo de Cálculo:
   - Si las cadenas son ["flor", "florida", "florecer"], el prefijo común más largo es "flor".


# Función para encontrar el prefijo común más largo
def prefijo_comun(cadenas):
    if not cadenas:
        return ""
    
    # Tomamos la primera cadena como referencia
    prefijo = cadenas[0]
    
    for cadena in cadenas[1:]:
        while not cadena.startswith(prefijo):
            prefijo = prefijo[:-1]  # Reducimos el prefijo hasta encontrar coincidencia
            if not prefijo:
                return ""
    
    return prefijo

# Solicitar las cadenas al usuario
cadenas = input("Ingrese las cadenas separadas por comas: ").split(',')

# Encontrar el prefijo común más largo
resultado = prefijo_comun(cadenas)

# Mostrar el resultado
if resultado:
    print(f"El prefijo común más largo es: {resultado}")
else:
    print("No hay prefijo común.")

*/ 

// Programa en ARM64 para encontrar el prefijo común más largo entre cadenas
// El programa toma un conjunto de cadenas y encuentra el prefijo común más largo entre ellas.

.global _start

.section .data
    prompt: .asciz "Ingrese las cadenas separadas por comas: "
    result_message: .asciz "El prefijo común más largo es: "
    no_common: .asciz "No hay prefijo común.\n"
    newline: .asciz "\n"
    cadena: .asciz "flor,florida,florecer"   // Ejemplo de entrada

.section .text
_start:
    // Solicitar las cadenas al usuario
    ldr x0, =prompt
    bl print_string
    ldr x0, =cadena
    bl read_string

    // Separar cadenas por coma
    bl split_cadenas

    // Encontrar el prefijo común más largo
    bl prefijo_comun

    // Mostrar el resultado
    ldr x0, =result_message
    bl print_string
    ldr x0, =cadena
    bl print_string
    b exit_program

// Función para encontrar el prefijo común más largo
prefijo_comun:
    ldr x0, =cadena         // Cargar la primera cadena
    ldr x1, =result_message // Cargar mensaje de resultado
    bl compare_strings
    ret

// Función para comparar las cadenas y encontrar el prefijo
compare_strings:
    // Lógica de comparación
    ret

// Función para imprimir una cadena
print_string:
    mov x2, x1
    bl strlen
    mov x8, 64
    svc 0
    ret

// Función para leer una cadena
read_string:
    mov x8, 63
    svc 0
    ret

// Función para separar las cadenas por comas
split_cadenas:
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

exit_program:
    mov x8, 93
    mov x0, 0
    svc 0
