# fortran_interface_example
Example of interfacing a fortran code with a c++ driver

## Build commands:
```
gfortran -c global.f95
g++ -c main.cpp
g++ -o main global.o main.o -lgfortran
```

## Code Structure

`main.cpp` contains the main driver of the code.  It calls a fortran `init` subroutine on every subdomain, and receives a pointer to an instance of a data structure defined in `global_data_module.f95`. These pointers can be passed around on the c++ side of the code.  In order to extract values from the data structure (for boundary value exchange, for instance) we can pass the address of this data structure into a fortran subroutine and pass back data as scalar values or c-style arrays.  

The subroutines inside `cwrappers.f95` are called from the C code, use the ISO c-bindings to translate the pointers from C to Fortran (and back) and then call the appropriate subroutine.  

Several subroutines contain code that was essentially just copied and pasted from the ADCIRC source code.  `read_fort14.f95` is basically exactly the same as the analogous portion of the ADCIRC code, but as you can see, when we want to write to (or read from) members of the `global` data type, we have to prepend `g%` to the variable name.  

We believe this approach will allow us to use almost all of the current fortran code and interface it with HPX and LGD in a threadsafe fashion. This code was tested in a multi-threaded HPX environment (although that code isn't in this repository) and as far as we can tell it seems to be thread safe. 

## Additional notes

Input files were created using `adcprep`, but due to some file reading issues, I manually cropped the PE****/fort.18 files up to the RESNODE lines.  The included mesh files in the folder "shin32" should work. Incidentally, the locations of all the input files are all hard-coded into the executable. 

To run the code, you also need to create a directory called "`output`", or it will complain about not being able to open output files.