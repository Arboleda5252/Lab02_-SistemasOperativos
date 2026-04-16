#!/bin/bash

set -u

PROJECT_DIR="/mnt/c/Users/carlo/OneDrive/Documentos/GitHub/Lab02_-SistemasOperativos"

# Limpiar archivos de prueba previos
cleanup_files() {
    rm -f salida.txt directorio.txt test.txt listado_tmp.txt 2>/dev/null
    true
}

run_case() {
    local title="$1"
    local input="$2"

    echo ""
    echo "===================================================="
    echo "$title"
    echo "===================================================="
    printf "%b" "$input" | ./wish
}

verify_file() {
    local filename="$1"
    if [ -f "$filename" ]; then
        echo "✓ Archivo '$filename' creado"
        echo "Contenido:"
        head -n 5 "$filename"
    else
        echo "✗ Archivo '$filename' NO se creó"
    fi
}

echo "===================================================="
echo "PRUEBAS DE REDIRECCION - WISH SHELL"
echo "===================================================="

cd "$PROJECT_DIR" || exit 1

cleanup_files

run_case "[PRUEBA 1] Redirección básica: ls > salida.txt" "ls > salida.txt\nexit\n"
verify_file "salida.txt"
echo ""

run_case "[PRUEBA 2] Redirección: pwd > directorio.txt" "pwd > directorio.txt\nexit\n"
verify_file "directorio.txt"
echo ""

run_case "[PRUEBA 3] Sobrescribir archivo: dos redirecciones al mismo archivo" "echo primero > test.txt\nexit\n"
printf "ls\n" | ./wish > /dev/null 2>&1
echo "Agregando archivo test.txt con 'echo primero'..."
run_case "[PRUEBA 3 continuación] Sobrescribir: echo segundo > test.txt" "echo segundo > test.txt\nexit\n"
echo "Contenido final de test.txt (debe ser solo 'segundo'):"
verify_file "test.txt"
echo ""

run_case "[PRUEBA 4] Redirección con argumentos: ls -la /tmp > listado_tmp.txt" "ls -la /tmp > listado_tmp.txt\nexit\n"
verify_file "listado_tmp.txt"
echo ""

run_case "[PRUEBA 5] Error: múltiples operadores > " "ls > file1 > file2\nexit\n"
echo ""

run_case "[PRUEBA 6] Error: > sin nombre de archivo" "ls >\nexit\n"
echo ""

run_case "[PRUEBA 7] Error: > al inicio" "> archivo.txt\nexit\n"
echo ""

run_case "[PRUEBA 8] Error: comando no existente con redirección" "noexiste > salida_error.txt\nexit\n"
echo "Verificando que salida_error.txt NO se creó..."
if [ ! -f "salida_error.txt" ]; then
    echo "✓ Correcto: archivo no se creó (como esperado)"
else
    echo "✗ Error: el archivo se creó cuando no debería"
fi
echo ""

echo "===================================================="
echo "PRUEBAS DE REDIRECCION COMPLETADAS"
echo "===================================================="

# Cleanup final
cleanup_files
