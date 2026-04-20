#!/bin/bash

set -u

PROJECT_DIR="/mnt/c/Users/carlo/OneDrive/Documentos/GitHub/Lab02_-SistemasOperativos"

run_case() {
	local title="$1"
	local input="$2"

	echo ""
	echo "===================================================="
	echo "$title"
	echo "===================================================="
	printf "%b" "$input" | ./wish
}

echo "╔════════════════════════════════════════════════════════╗"
echo "║     PRUEBAS DE COMANDOS BUILT-IN - WISH SHELL        ║"
echo "╚════════════════════════════════════════════════════════╝"

cd "$PROJECT_DIR" || exit 1

run_case "[PRUEBA 1] exit sin argumentos" "exit\n"
run_case "[PRUEBA 2] exit con argumentos (error)" "exit 1\n"
run_case "[PRUEBA 3] cd correcto y verificación con pwd" "pwd\ncd /tmp\npwd\nexit\n"
run_case "[PRUEBA 4] cd sin argumentos (error)" "cd\nexit\n"
run_case "[PRUEBA 5] cd con múltiples argumentos (error)" "cd /tmp /home\nexit\n"
run_case "[PRUEBA 6] cd a directorio inexistente (error)" "pwd\ncd /ruta/inexistente\npwd\nexit\n"
run_case "[PRUEBA 7] path vacío: no ejecuta programas externos" "path\npwd\nexit\n"
run_case "[PRUEBA 8] path con rutas válidas" "path /bin /usr/bin\nexit\n"

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║          TODAS LAS PRUEBAS COMPLETADAS ✓              ║"
echo "╚════════════════════════════════════════════════════════╝"
