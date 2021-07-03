find_package(SDL2 CONFIG REQUIRED)
find_package(freetype CONFIG REQUIRED)
include("${CMAKE_CURRENT_LIST_DIR}/SDL2_ttfTargets.cmake")

if(NOT TARGET SDL_ttf::SDL_ttf)
  set_target_properties(
      SDL2_ttf::SDL2_ttf
      PROPERTIES
      IMPORTED_GLOBAL True
  )
  add_library(SDL_ttf::SDL_ttf ALIAS SDL2_ttf::SDL2_ttf)
endif()
