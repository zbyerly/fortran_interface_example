# fortran_interface_example
Example of interfacing a fortran code with a c++ driver

## Build commands:
```
gfortran -c global.f95
g++ -c main.cpp
g++ -o main global.o main.o -lgfortran
```