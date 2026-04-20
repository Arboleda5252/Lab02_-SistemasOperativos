#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>

#define MAX_ARGS 100
#define MAX_PATH_LEN 512
#define MAX_PATHS 100
#define MAX_LINE 4096

char error_message[] = "An error has occurred\n";

char *shell_path[MAX_PATHS];
int path_count = 0;

void print_error(void) {
    write(STDERR_FILENO, error_message, strlen(error_message));
}

void clear_path(void) {
    int i;
    for (i = 0; i < path_count; i++) {
        free(shell_path[i]);
        shell_path[i] = NULL;
    }
    path_count = 0;
}

void init_path(void) {
    clear_path();
    shell_path[0] = strdup("/bin");
    shell_path[1] = strdup("/usr/bin");
    if (shell_path[0] == NULL || shell_path[1] == NULL) {
        print_error();
        exit(1);
    }
    path_count = 2;
}

int set_path(char **paths, int count) {
    int i;
    clear_path();
    for (i = 0; i < count; i++) {
        shell_path[i] = strdup(paths[i]);
        if (shell_path[i] == NULL) {
            print_error();
            clear_path();
            return -1;
        }
    }
    path_count = count;
    return 0;
}

int find_command(const char *cmd, char *fullpath) {
    int i;
    for (i = 0; i < path_count; i++) {
        snprintf(fullpath, MAX_PATH_LEN, "%s/%s", shell_path[i], cmd);
        if (access(fullpath, X_OK) == 0) {
            return 1;
        }
    }
    return 0;
}

int line_is_blank(const char *line) {
    const char *p = line;
    while (*p != '\0') {
        if (*p != ' ' && *p != '\t' && *p != '\n' && *p != '\r') {
            return 0;
        }
        p++;
    }
    return 1;
}

void normalize_operators(const char *src, char *dst, size_t dst_size) {
    size_t i = 0;
    while (*src != '\0' && i + 1 < dst_size) {
        if (*src == '>' || *src == '&') {
            if (i + 3 >= dst_size) {
                break;
            }
            dst[i++] = ' ';
            dst[i++] = *src;
            dst[i++] = ' ';
        } else {
            dst[i++] = *src;
        }
        src++;
    }
    dst[i] = '\0';
}

int tokenize(char *line, char **tokens) {
    int count = 0;
    char *rest = line;
    char *part;

    while ((part = strsep(&rest, " \t\n\r")) != NULL) {
        if (*part == '\0') {
            continue;
        }
        if (count >= MAX_ARGS - 1) {
            return -1;
        }
        tokens[count++] = part;
    }
    tokens[count] = NULL;
    return count;
}

int handle_builtin(char **args, int argc) {
    if (argc == 0) {
        return 1;
    }

    if (strcmp(args[0], "exit") == 0) {
        if (argc != 1) {
            print_error();
            return 1;
        }
        clear_path();
        exit(0);
    }

    if (strcmp(args[0], "cd") == 0) {
        if (argc != 2) {
            print_error();
            return 1;
        }
        if (chdir(args[1]) != 0) {
            print_error();
        }
        return 1;
    }

    if (strcmp(args[0], "path") == 0) {
        if (set_path(&args[1], argc - 1) != 0) {
            print_error();
        }
        return 1;
    }

    return 0;
}

void process_line(char *line) {
    char normalized[MAX_LINE];
    char *tokens[MAX_ARGS];
    int token_count;
    int i;
    int start;
    pid_t pids[MAX_ARGS];
    int pid_count = 0;

    if (line == NULL || line_is_blank(line)) {
        return;
    }

    normalize_operators(line, normalized, sizeof(normalized));
    token_count = tokenize(normalized, tokens);
    if (token_count < 0) {
        print_error();
        return;
    }
    if (token_count == 0) {
        return;
    }

    start = 0;
    for (i = 0; i <= token_count; i++) {
        if (i == token_count || strcmp(tokens[i], "&") == 0) {
            char *cmd_tokens[MAX_ARGS];
            char *exec_args[MAX_ARGS];
            char *redir_file = NULL;
            int cmd_len = i - start;
            int j;
            int redir_index = -1;
            int exec_argc = 0;
            char fullpath[MAX_PATH_LEN];

            if (cmd_len == 0) {
                start = i + 1;
                continue;
            }

            for (j = 0; j < cmd_len; j++) {
                cmd_tokens[j] = tokens[start + j];
            }
            cmd_tokens[cmd_len] = NULL;

            for (j = 0; j < cmd_len; j++) {
                if (strcmp(cmd_tokens[j], ">") == 0) {
                    if (redir_index != -1) {
                        print_error();
                        return;
                    }
                    redir_index = j;
                }
            }

            if (redir_index != -1) {
                if (redir_index == 0 || redir_index + 2 != cmd_len) {
                    print_error();
                    return;
                }
                redir_file = cmd_tokens[redir_index + 1];
                cmd_len = redir_index;
            }

            if (cmd_len == 0) {
                print_error();
                return;
            }

            for (j = 0; j < cmd_len; j++) {
                exec_args[j] = cmd_tokens[j];
            }
            exec_args[cmd_len] = NULL;
            exec_argc = cmd_len;

            if (token_count == cmd_len && start == 0) {
                if (handle_builtin(exec_args, exec_argc)) {
                    start = i + 1;
                    continue;
                }
            } else if (handle_builtin(exec_args, exec_argc)) {
                print_error();
                return;
            }

            if (!find_command(exec_args[0], fullpath)) {
                print_error();
                start = i + 1;
                continue;
            }

            {
                pid_t pid = fork();
                if (pid < 0) {
                    print_error();
                    return;
                }

                if (pid == 0) {
                    if (redir_file != NULL) {
                        int fd = open(redir_file, O_WRONLY | O_CREAT | O_TRUNC, 0666);
                        if (fd < 0) {
                            print_error();
                            exit(1);
                        }
                        if (dup2(fd, STDOUT_FILENO) < 0 || dup2(fd, STDERR_FILENO) < 0) {
                            close(fd);
                            print_error();
                            exit(1);
                        }
                        close(fd);
                    }

                    execv(fullpath, exec_args);
                    print_error();
                    exit(1);
                }

                pids[pid_count++] = pid;
            }

            start = i + 1;
        }
    }

    for (i = 0; i < pid_count; i++) {
        waitpid(pids[i], NULL, 0);
    }
}

int main(int argc, char *argv[]) {
    FILE *input = stdin;
    char *line = NULL;
    size_t len = 0;
    ssize_t nread;

    if (argc > 2) {
        print_error();
        exit(1);
    }

    if (argc == 2) {
        input = fopen(argv[1], "r");
        if (input == NULL) {
            print_error();
            exit(1);
        }
    }

    init_path();

    while (1) {
        if (input == stdin) {
            printf("wish> ");
            fflush(stdout);
        }

        nread = getline(&line, &len, input);
        if (nread == -1) {
            if (input != stdin) {
                fclose(input);
            }
            free(line);
            clear_path();
            exit(0);
        }

        process_line(line);
    }
}