# PRUEBAS DE COMANDOS BUILT-IN - WISH SHELL

Estos casos están preparados para tomar captura en terminal. En el código actual, los built-ins son `exit`, `cd` y `path`.

## Caso 1: `exit` sin argumentos
```bash
wish> exit
```
Resultado esperado: el shell se cierra sin mostrar error.

## Caso 2: `exit` con argumentos
```bash
wish> exit 1
```
Resultado esperado: `An error has occurred` y el shell sigue activo.

## Caso 3: `cd` con un directorio válido
```bash
wish> pwd
wish> cd /tmp
wish> pwd
wish> exit
```
Resultado esperado: el segundo `pwd` muestra `/tmp`.

## Caso 4: `cd` sin argumentos
```bash
wish> cd
```
Resultado esperado: `An error has occurred`.

## Caso 5: `cd` con más de un argumento
```bash
wish> cd /tmp /home
```
Resultado esperado: `An error has occurred`.

## Caso 6: `cd` con directorio inexistente
```bash
wish> pwd
wish> cd /ruta/inexistente
wish> pwd
wish> exit
```
Resultado esperado: aparece `An error has occurred` y el directorio actual no cambia.

## Caso 7: `path` vacío
```bash
wish> path
wish> pwd
wish> exit
```
Resultado esperado: `pwd` falla con `An error has occurred` porque no hay rutas de búsqueda para ejecutar programas externos.

## Caso 8: `path` con rutas válidas
```bash
wish> path /bin /usr/bin
wish> exit
```
Resultado esperado: no aparece error y el shell acepta programas externos de esas rutas.

## Cómo correr el bloque completo para captura
```bash
bash pruebas_builtin.sh
```

## Nota
Si el enunciado de tu guía dice `route` o `chd`, en este proyecto equivalen a `path` y `cd` respectivamente, pero el código implementado usa los nombres reales `path` y `cd`.
