option(HUNTER_ENABLED "Enable Hunter package manager" OFF)

if(HUNTER_ENABLED)
cmake_minimum_required(VERSION 3.2)

include(cmake/HunterGate.cmake)
HunterGate(
  URL "https://github.com/drodin/hunter/archive/refs/heads/pr.SDL2.zip"
  SHA1 "38441cc365a298f42a03784cd041d36198435dc7"
)
else()
if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  message(FATAL_ERROR "Prevented in-tree built. Please create a build directory outside of the SDL_ttf source code and call cmake from there")
endif()

##### general #####
cmake_minimum_required(VERSION 3.0)
endif()
project(SDL_ttf C)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

if (NOT HUNTER_ENABLED)
find_package(SDL2 REQUIRED)
find_package(Freetype REQUIRED)
find_package(PkgConfig QUIET)
else()
hunter_add_package(SDL2)
hunter_add_package(freetype)
find_package(SDL2 CONFIG REQUIRED)
find_package(freetype CONFIG REQUIRED)
endif()

set(SDL_TTF_MAJOR_VERSION 2)
set(SDL_TTF_MINOR_VERSION 0)
set(SDL_TTF_MICRO_VERSION 15)
set(SDL_TTF_INTERFACE_AGE 1)
set(SDL_TTF_BINARY_AGE 15)
set(SDL_TTF_VERSION "${SDL_TTF_MAJOR_VERSION}.${SDL_TTF_MINOR_VERSION}.${SDL_TTF_MICRO_VERSION}")

##### library generation #####
add_library(SDL2_ttf SDL_ttf.c SDL_ttf.h)
target_link_libraries(SDL2_ttf SDL2::SDL2 Freetype::Freetype)
target_include_directories(SDL2_ttf PUBLIC $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/SDL2>)

install(
  TARGETS SDL2_ttf
  EXPORT SDL2_ttfTargets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
install(
  FILES SDL_ttf.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/SDL2
)
if(HUNTER_ENABLED)
install(
  FILES SDL_ttf.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/SDL_ttf
)
endif()

##### export files #####
if(NOT HUNTER_ENABLED)
if (APPLE)
  set(PKG_PREFIX "SDL2_ttf.framework/Resources")
elseif (WIN32)
  set(PKG_PREFIX "cmake")
else ()
  set(PKG_PREFIX "lib/cmake/SDL2")
endif ()
else()
set(PKG_PREFIX "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")
endif()

if(NOT HUNTER_ENABLED)
write_basic_package_version_file("${CMAKE_BINARY_DIR}/SDL2_ttfConfigVersion.cmake"
  VERSION ${SDL_TTF_VERSION}
  COMPATIBILITY AnyNewerVersion
)
else()
write_basic_package_version_file("${CMAKE_BINARY_DIR}/SDL_ttfConfigVersion.cmake"
  VERSION ${SDL_TTF_VERSION}
  COMPATIBILITY AnyNewerVersion
)
endif()

install(
  EXPORT SDL2_ttfTargets
  FILE SDL2_ttfTargets.cmake
  NAMESPACE SDL2_ttf::
  DESTINATION ${PKG_PREFIX}
)
if(NOT HUNTER_ENABLED)
install(
  FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/SDL2_ttfConfig.cmake
    ${CMAKE_BINARY_DIR}/SDL2_ttfConfigVersion.cmake
  DESTINATION ${PKG_PREFIX}
  COMPONENT Devel
)
else()
install(
  FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/SDL_ttfConfig.cmake
    ${CMAKE_BINARY_DIR}/SDL_ttfConfigVersion.cmake
  DESTINATION ${PKG_PREFIX}
  COMPONENT Devel
)
endif()

if (NOT HUNTER_ENABLED)
##### pkg-config #####
if (PKG_CONFIG_FOUND)
  set(SDL_VERSION 2.0.0)
  set(prefix ${CMAKE_INSTALL_PREFIX})
  set(exec_prefix "\${prefix}")
  set(libdir "\${exec_prefix}/lib${LIB_SUFFIX}")
  set(bindir "\${exec_prefix}/bin")
  set(includedir "\${prefix}/include")

  configure_file("${SDL_ttf_SOURCE_DIR}/SDL2_ttf.pc.in"
    "${SDL_ttf_BINARY_DIR}/SDL2_ttf.pc" @ONLY)

  if (CMAKE_SYSTEM_NAME MATCHES FreeBSD)
    # FreeBSD uses ${PREFIX}/libdata/pkgconfig
    install(FILES ${SDL_ttf_BINARY_DIR}/SDL2_ttf.pc DESTINATION "libdata/pkgconfig")
  else ()
    install(FILES ${SDL_ttf_BINARY_DIR}/SDL2_ttf.pc
      DESTINATION "lib${LIB_SUFFIX}/pkgconfig")
  endif ()
endif ()
endif()
