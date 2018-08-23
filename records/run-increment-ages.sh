#!/bin/bash

as --32 increment-ages.s -o increment-ages.o
as --32 read-record.s -o read-record.o
as --32 write.s -o write-record.o

ld increment-ages.o read-record.o write-record.o -o increment-ages -m elf_i386

./increment-ages

printf "original data:\n\n"

cat test.dat

printf "\n\n\nresult data:\n\n"

cat test.out.dat

printf "\n\ndone."

rm test.out.dat increment-ages.o read-record.o write-record.o increment-ages
