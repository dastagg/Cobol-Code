#!/bin/bash

# The program to run
PGM=BDS0704

# Location of copylibs
SYSLIB="../cpy"

# clean up
rm ../bin/$PGM

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I $SYSLIB 

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
