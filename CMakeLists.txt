cmake_minimum_required(VERSION 3.15)
project(s2_py)

# Link s2 statically into _pywraps2.so so the wheel is self-contained
set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
# Static libs must be PIC to link into a shared .so (required on aarch64)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# On Linux (manylinux), only Development.Module is available — no libpython.so.
# On macOS, the full Development (Module + Embed) is available and needed for linking.
if(APPLE)
  find_package(Python3 COMPONENTS Interpreter Development)
else()
  find_package(Python3 COMPONENTS Interpreter Development.Module)
  # Satisfy the submodule's find_package(Python3 ... Development) requirement
  set(Python3_FOUND TRUE)
  set(Python3_Development_FOUND TRUE)
  set(Python3_Development.Embed_FOUND TRUE)
  # On Linux, SWIG modules don't link libpython — symbols resolve at runtime
  if(NOT Python3_LIBRARIES)
    set(Python3_LIBRARIES "")
  endif()
endif()

# Prevent the s2geometry submodule from re-running find_package(Python3)
macro(find_package pkg)
  if("${pkg}" STREQUAL "Python3")
    # no-op: already found
  else()
    _find_package(${ARGV})
  endif()
endmacro()

add_subdirectory(s2geometry)

# Restore find_package
macro(find_package)
  _find_package(${ARGV})
endmacro()

# Install the SWIG extension and Python wrapper into the s2_py package
install(TARGETS _pywraps2 DESTINATION s2_py COMPONENT s2_py)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/s2geometry/python/pywraps2.py" DESTINATION s2_py COMPONENT s2_py)
