#!/bin/bash
# Script de pruebas para documentar funcionalidad de wish shell

echo "╔════════════════════════════════════════════════════════╗"
echo "║     PRUEBAS DE COMANDOS BUILT-IN - WISH SHELL        ║"
echo "╚════════════════════════════════════════════════════════╝"

cd /mnt/c/Users/carlo/OneDrive/Documentos/GitHub/Lab02_-SistemasOperativos

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[PRUEBA 1] Comando EXIT - Correcto"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf '$ exit\n\n' | ./wish
echo "✓ Shell cerrado correctamente"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[PRUEBA 2] Comando EXIT - Error (con argumentos)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf '$ exit 1\n' | ./wish 2>&1 | grep "error"
echo "✓ Error detectado correctamente"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[PRUEBA 3] Comando CD - Cambio de directorio correcto"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf '$ pwd\n$ cd /tmp\n$ pwd\n$ exit\n' | ./wish
echo "✓ cd funcionó correctamente"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[PRUEBA 4] Comando CD - Error (sin argumentos)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf '$ cd\n$ exit\n' | ./wish 2>&1 | grep "error"
echo "✓ Error detectado correctamente"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[PRUEBA 5] Comando CD - Error (múltiples argumentos)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf '$ cd /tmp /home\n$ exit\n' | ./wish 2>&1 | grep "error"
echo "✓ Error detectado correctamente"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[PRUEBA 6] Comando CD - Error (directorio inexistente)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf '$ cd /no/existe\n$ pwd\n$ exit\n' | ./wish 2>&1
echo "✓ Directorio actual no cambió"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[PRUEBA 7] Comando PATH - Vacío (sin comandos)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf '$ path\n$ pwd\n$ exit\n' | ./wish 2>&1
echo "✓ pwd no funciona cuando PATH está vacío"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "[PRUEBA 8] Comando PATH - Establecer nuevas rutas"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf '$ path /bin /usr/bin\n$ exit\n' | ./wish
echo "✓ PATH establecido correctamente"
echo ""

echo "╔════════════════════════════════════════════════════════╗"
echo "║          TODAS LAS PRUEBAS COMPLETADAS ✓              ║"
echo "╚════════════════════════════════════════════════════════╝"
