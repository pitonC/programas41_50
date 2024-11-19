/* 
1. Nombre del Programa: Escribir en un Archivo
2. Descripción del Programa: Este programa escribe una cadena de texto en un archivo. Si el archivo no existe, se crea. El programa escribe un mensaje en el archivo y luego lo cierra.
3. Ejemplo de Cálculo:
   - El programa escribe el texto "Hola, este es un mensaje en un archivo." en un archivo llamado `salida.txt`.


# Función para escribir en un archivo
def escribir_en_archivo():
    with open("salida.txt", "w") as archivo:
        archivo.write("Hola, este es un mensaje en un archivo.\n")
        archivo.write("Este es un segundo mensaje en el archivo.\n")

# Llamar a la función para escribir en el archivo
escribir_en_archivo()

# Confirmar que el mensaje fue escrito
print("El mensaje ha sido escrito en el archivo 'salida.txt'.")

*/ 
// Programa en ARM64 para escribir en un archivo
// El programa escribe una cadena de texto en un archivo. Si el archivo no existe, se crea.

.global _start

.section .data
    archivo_name: .asciz "salida.txt"  // Nombre del archivo
    mensaje: .asciz "Hola, este es un mensaje en un archivo.\nEste es un segundo mensaje en el archivo.\n"

.section .text
_start:
    // Abrir el archivo para escritura (modo "w")
    ldr x0, =archivo_name  // Nombre del archivo
    mov x1, 577            // Opción de apertura para escritura (modo "w")
    mov x8, 56             // Número de servicio para abrir archivo
    svc 0
    mov x19, x0            // Guardar el descriptor de archivo

    // Escribir el mensaje en el archivo
    ldr x0, =mensaje       // Mensaje a escribir
    mov x1, 56             // Longitud del mensaje
    mov x8, 64             // Número de servicio para escribir en archivo
    svc 0

    // Cerrar el archivo
    mov x0, x19            // Descriptor de archivo
    mov x8, 57             // Número de servicio para cerrar archivo
    svc 0

    // Imprimir un mensaje de confirmación (en consola)
    ldr x0, =mensaje       // Mensaje a imprimir
    bl print_string

    // Terminar el programa
    mov x8, 93
    mov x0, 0
    svc 0

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

