all: libtssa tssa_test

tssa_test: libtssa tssa_test.cpp
	g++ -g tssa_test.cpp -o tssa_test -lpthread -L./ -ltssa

libtssa: tssa.cpp tssa.h
	g++ -g -c tssa.cpp -o tssa.o
	ar rcs libtssa.a tssa.o

