# Laboratorio 02 - Sistemas Operativos
Elaborado por: 
- Carlos Andres Zuluaga Amaya
  andres.zuluaga6@udea.edu.co
- Duván Antonio Arboleda Botero
  duvan.arboleda1@udea.edu.co

Link de video: 

## Introducción
En este laboratorio se implementa un shell básico (`wish`) que funciona como un intérprete de comandos simple.
El shell puede ejecutarse tanto en modo interactivo como en modo batch (leyendo comandos desde un archivo).

## Objetivo
Implementar un shell que:
- Lee comandos del usuario (modo interactivo) o desde un archivo (modo batch)
- Ejecuta programas externos usando `fork()` y `execv()`
- Implementa comandos built-in: `exit`, `cd` y `path`
- Maneja errores adecuadamente

## Compilación

### En Linux/Unix directamente:
```bash
gcc -Wall -o wish wish.c
```

### En Windows (usando WSL):
```bash
wsl bash -c "cd /ruta/al/proyecto && gcc -Wall -o wish wish.c"
```

## Ejecución

### Modo interactivo:
```bash
./wish
wish> pwd
wish> cd /tmp
wish> exit
```

### Modo batch (desde archivo):
```bash
./wish comandos.txt
```

Donde `comandos.txt` contiene los comandos a ejecutar, uno por línea.

## Desarrollo

### Características implementadas:

#### 1. **Comandos Built-in**

- **`exit`**: Finaliza el shell. No acepta argumentos.
  - ✓ `exit` → Cierra el shell
  - ✗ `exit 1` → Error

- **`cd <directorio>`**: Cambia de directorio. Requiere exactamente 1 argumento.
  - ✓ `cd /tmp` → Funciona
  - ✗ `cd` → Error (sin argumentos)
  - ✗ `cd /tmp /home` → Error (múltiples argumentos)
  - ✗ `cd /inexistente` → Error (directorio no existe)

- **`path <dir1> <dir2> ...`**: Establece la ruta de búsqueda del shell. Puede tomar 0 o más argumentos.
  - ✓ `path /bin /usr/bin` → Establece PATH
  - ✓ `path` → Borra PATH (no se pueden ejecutar programas)
  - Nota: Sobrescribe el PATH anterior

#### 2. **Ejecución de programas externos**
- Busca ejecutables en los directorios del PATH
- Soporta argumentos con espacios
- Maneja errores si el programa no existe

#### 3. **Modos de operación**
- **Interactivo**: Muestra prompt `wish>` y lee de stdin
- **Batch**: Lee comandos desde archivo especificado como argumento
- Ambos modos se cierran con EOF o comando `exit`

### Funciones principales:

- `init_path()`: Inicializa PATH con valores por defecto (`/bin`, `/usr/bin`)
- `set_path()`: Cambia el PATH del shell
- `find_command()`: Busca un ejecutable en los directorios del PATH
- `process_command()`: Procesa una línea de comando
- `main()`: Ciclo principal del shell

### Validaciones de error:
Todos los errores se reportan con: `An error has occurred\n`

Casos que generan errores:
- Comando no existente
- Argumentos inválidos para built-ins
- Problemas al cambiar directorio
- Fallos en fork() o execv()
