${name}: main.o one.o
	gcc main.o one.o -o $@
main.o: main.c one.h
	gcc main.c -c
one.o: one.c one.h
	gcc one.c -c
