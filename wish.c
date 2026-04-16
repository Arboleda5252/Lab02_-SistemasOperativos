#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>     // fork, execv
#include <sys/types.h>
#include <sys/wait.h>   // waitpid

#define MAX_ARGS 100

int main() {
    char *line = NULL;
    size_t len = 0;
    ssize_t nread;

    while (1) {
        // Mostrar el prompt
        printf("wish> ");
        fflush(stdout);

        // Leer una linea completa
        nread = getline(&line, &len, stdin);

        // Salir si se alcanza EOF
        if (nread == -1) {
            free(line);
            exit(0);
        }

        // Quitar el salto de linea
        if (nread > 0 && line[nread - 1] == '\n') {
            line[nread - 1] = '\0';
        }
        if (strlen(line) == 0) {
            continue;
        }

        // Guardar partes del comando y sus argumentos
        char *args[MAX_ARGS];
        int argc = 0;
        char *resto = line;
        char *parte;

        // Implementacion de strsep
        while ((parte = strsep(&resto, " \t")) != NULL) {
            if (strlen(parte) == 0) {
                continue;
            }

            args[argc] = parte;
            argc++;

            if (argc >= MAX_ARGS - 1) {
                break;
            }
        }

        args[argc] = NULL;

        // Ruta temporal del ejecutable en /bin
        for (int i = 0; i < num_paths; i++) {
            snprintf(ruta, sizeof(ruta), "%s/%s", paths[i], args[0]);
            // Access()
            if (access(ruta, X_OK) == 0) {
                encontrado = 1;
                break;
        }
}

        // fork(): crear proceso hijo
        pid_t pid = fork();

        if (pid < 0) {
            // Error
            fprintf(stderr, "An error has occurred\n");
            continue;
        }

        if (pid == 0) {
            // execv(): ejecutar el comando
            execv(ruta, args);
            fprintf(stderr, "An error has occurred\n");
            exit(1);
        } else {
            // waitpid():Proceso padre, esperar a que termine el hijo
            waitpid(pid, NULL, 0);
        }
    }

    free(line);
    return 0;
}