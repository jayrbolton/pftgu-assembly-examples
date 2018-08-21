#!/bin/sh

if [ ! -f $1.s ]; then
  echo "file not found!"
  echo "pass the name of the file minus its extension"
  exit 1
fi

as $1.s -o $1.o --32

# if [-f $2]; then
#   as $2 -o $2.o
# fi
# if [-f $3]; then
#   as $3 -o $3.o
# fi

if [ ! -f $1.o ]; then
  echo "failed to compile!"
  exit 1
fi

ld $1.o -o $1 -m elf_i386
# if [-f $2]; then
# fi
# if [-f $3]; then
# fi

if [ ! -f $1 ]; then
  echo "failed to link!"
  rm $1.o
  exit 1
fi

echo 'running...'
./$1 $2 $3 $4 $5 ; echo $?
echo 'done running.'
rm $1.o
rm $1
echo 'done removing.'
