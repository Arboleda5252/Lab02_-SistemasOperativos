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

echo "===================================================="
echo "PRUEBAS DE COMANDOS EN PARALELO (&) - WISH"
echo "===================================================="

cd "$PROJECT_DIR" || exit 1

run_case "[PRUEBA 1] Tres comandos en paralelo" "echo A & echo B & echo C\nexit\n"

echo ""
echo "Nota: A, B y C pueden salir en cualquier orden."

run_case "[PRUEBA 2] Paralelo con argumentos" "ls -d /tmp & echo FIN\nexit\n"

run_case "[PRUEBA 3] Un comando invalido entre comandos validos" "echo OK1 & noexiste & echo OK2\nexit\n"

echo ""
echo "En la prueba 3 debe aparecer una linea con: An error has occurred"

echo ""
echo "===================================================="
echo "[PRUEBA 4] Verificar que wish espera a todos los procesos"
echo "===================================================="

start=$(date +%s)
printf "sleep 2 & echo LISTO\nexit\n" | ./wish > /tmp/wish_parallel_wait.txt
end=$(date +%s)
elapsed=$((end - start))

cat /tmp/wish_parallel_wait.txt
echo "Tiempo transcurrido aproximado: ${elapsed}s"

if [ "$elapsed" -ge 2 ]; then
    echo "OK: wish espero a que termine sleep 2 antes de finalizar."
else
    echo "ERROR: el tiempo fue menor a 2s; revisar wait()/waitpid()."
fi

rm -f /tmp/wish_parallel_wait.txt

echo ""
echo "===================================================="
echo "PRUEBAS DE PARALELO COMPLETADAS"
echo "===================================================="
