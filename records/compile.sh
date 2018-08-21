#!/bin/bash

as --32 read-record.s -o read-record.o
as --32 count-chars.s -o count-chars.o
as --32 write-newline.s -o write-newline.o
as --32 read-records.s -o read-records.o

ld read-record.o count-chars.o write-newline.o read-records.o -o read-records -m elf_i386

./read-records

echo 'done.'
rm read-record.o count-chars.o write-newline.o read-records.o read-records
