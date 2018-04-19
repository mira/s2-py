cmake_minimum_required(VERSION 2.8.12)
project(s2_py)

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)

if (APPLE)
   set(CMAKE_MACOSX_RPATH TRUE)
   set_target_properties(_simple_module PROPERTIES INSTALL_RPATH "@loader_path")
else()
   set(CMAKE_INSTALL_RPATH "$ORIGIN")
endif()

add_subdirectory(s2geometry)