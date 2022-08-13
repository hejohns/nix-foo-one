one: main.o one.o
	gcc main.o one.o -o $@
	mkdir -p $(out)/bin
	mv $@ $(out)/bin/
main.o: main.c one.h
	gcc main.c -c
one.o: one.c one.h
	gcc one.c -c
