#!/bin/bash

set -u

PROJECT_DIR="/mnt/c/Users/carlo/OneDrive/Documentos/GitHub/Lab02_-SistemasOperativos"

cd "$PROJECT_DIR" || exit 1

echo "PRUEBAS 2.7 - MANEJO DE ERRORES"
echo "===================================================="

echo ""
echo "[PRUEBA 1] Comando invalido: debe imprimir error y continuar"
printf "noexiste\npwd\nexit\n" | ./wish > /tmp/p1_stdout.txt 2> /tmp/p1_stderr.txt
echo "STDERR:"
cat /tmp/p1_stderr.txt
echo "STDOUT (ultimas lineas):"
tail -n 5 /tmp/p1_stdout.txt

echo ""
echo "[PRUEBA 2] Built-in con error: exit con argumento; shell debe continuar"
printf "exit 1\npwd\nexit\n" | ./wish > /tmp/p2_stdout.txt 2> /tmp/p2_stderr.txt
echo "STDERR:"
cat /tmp/p2_stderr.txt
echo "STDOUT (ultimas lineas):"
tail -n 5 /tmp/p2_stdout.txt

echo ""
echo "[PRUEBA 3] Invocacion con mas de un batch file: debe terminar con exit(1)"
./wish a.txt b.txt > /tmp/p3_stdout.txt 2> /tmp/p3_stderr.txt
p3_code=$?
echo "EXIT CODE: $p3_code"
echo "STDERR:"
cat /tmp/p3_stderr.txt

echo ""
echo "[PRUEBA 4] Batch file inexistente: debe terminar con exit(1)"
./wish archivo_que_no_existe.txt > /tmp/p4_stdout.txt 2> /tmp/p4_stderr.txt
p4_code=$?
echo "EXIT CODE: $p4_code"
echo "STDERR:"
cat /tmp/p4_stderr.txt

echo ""
echo "===================================================="
echo "VALIDACION ESPERADA"
echo "- Prueba 1: error en stderr y luego pwd ejecutado"
echo "- Prueba 2: error en stderr y luego pwd ejecutado"
echo "- Prueba 3: EXIT CODE = 1"
echo "- Prueba 4: EXIT CODE = 1"
echo "===================================================="

rm -f /tmp/p1_stdout.txt /tmp/p1_stderr.txt \
      /tmp/p2_stdout.txt /tmp/p2_stderr.txt \
      /tmp/p3_stdout.txt /tmp/p3_stderr.txt \
      /tmp/p4_stdout.txt /tmp/p4_stderr.txt
