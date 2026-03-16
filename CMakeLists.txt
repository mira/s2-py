cmake_minimum_required(VERSION 3.18)
project(s2_py)

# Link s2 statically into the wheel so it's self-contained
set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
# Static libs must be PIC to link into a shared .so (required on aarch64)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
# Disable tests (no googletest needed)
set(BUILD_TESTS OFF CACHE BOOL "" FORCE)
# Enable Python bindings
set(WITH_PYTHON ON CACHE BOOL "" FORCE)

add_subdirectory(s2geometry)

# Install the SWIG extension and Python wrapper into the s2_py package
install(TARGETS s2geometry DESTINATION s2_py COMPONENT s2_py)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/s2geometry/python/s2geometry.py"
        DESTINATION s2_py COMPONENT s2_py)
