CC = gcc
CFLAGS = -std=c11 -Wall -Wextra -O2

all: reverse

reverse: reverse.c
	$(CC) $(CFLAGS) reverse.c -o reverse

clean:
	-del /Q reverse reverse.exe >NUL 2>NUL
