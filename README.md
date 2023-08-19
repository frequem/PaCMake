# PaCMake
C/C++ package manager written in CMake for easy integration.
## User How-to
#### Setup
To start using PaCMake copy the [PaCMakeLoader.cmake][PaCMakeLoader] file into your project somewhere,
then include it in your *CMakeLists.txt* **before** the *project* command.
```cmake
include("cmake/PaCMakeLoader.cmake")
project(example)
```
#### Adding a package to your project
Adding a package is as simple as calling *pacmake_add_package* **after** the *project* command and then linking to the target.
```cmake
project(test)
pacmake_add_package(libpng 1.6.40 SHARED)
add_executable(test ${test_sources})
target_link_libraries(test PUBLIC libpng::libpng)
```
Both the library type (here: SHARED) and version (here: 1.6.40) arguments are optional.
Examples for each respective package can be found in [the package folders][packages].

[PaCMakeLoader]: <https://github.com/frequem/PaCMake/blob/master/PaCMakeLoader.cmake>
[packages]: <https://github.com/frequem/PaCMake/tree/master/package>
