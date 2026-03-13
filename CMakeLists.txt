cmake_minimum_required(VERSION 3.5)
project(s2_py)

# Link s2 statically into _pywraps2.so so the wheel is self-contained
set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)

add_subdirectory(s2geometry)

# Install the SWIG extension and Python wrapper into the s2_py package
install(TARGETS _pywraps2 DESTINATION s2_py COMPONENT s2_py)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/s2geometry/python/pywraps2.py" DESTINATION s2_py COMPONENT s2_py)
