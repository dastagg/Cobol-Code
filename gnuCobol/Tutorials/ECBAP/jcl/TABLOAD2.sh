#!/bin/bash

PGM=TABLOAD2
SYSLIB="$DHOME/dev/cobol/Cobol-Projects/common/cpy"

cobc -x ../cbl/$PGM.cbl -I $SYSLIB -o ../bin/$PGM

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
