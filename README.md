_Programming from the Ground Up assembly code examples_

This repo contains the code examples as found in the book [Programming from the Ground Up](https://savannah.nongnu.org/projects/pgubook/). 

The `./run.sh` script will compile and execute an x86 assembly file in the root directory, print the results, and clean up all compiled files. It takes the name of the file (minus the file extension) as its argument.

The example for reading and writing records from a file lives in `/records` and can be compiled
and run with `(cd records; bash compile.sh)`.
