cmake_minimum_required (VERSION 3.0)
project (nss_maria VERSION 0.9 LANGUAGES C)

set(ENV{COMPILE_OPTIONS} "\
-pipe;-pedantic;-Wall;-Wextra;-Wshadow;-Wno-missing-field-initializers;\
-Wno-unused-parameter;-Wold-style-definition;\
-Wmissing-declarations;\
-Wmissing-prototypes;-Wstrict-prototypes;-Wredundant-decls;-Wmissing-noreturn;\
-Wpointer-arith;\
-Wcast-align;-Wwrite-strings;-Winline;-Wformat-nonliteral;-Wformat-security;\
-Wswitch-enum;\
-Winit-self;-Wmissing-include-dirs;-Wundef;-Waggregate-return;-Wnested-externs;\
-Wunavailable-declarations;-Winvalid-pch;-Wcast-qual;\
--std=c11\
")
set(ENV{DEBUG_OPTIONS} "-g;-ggdb;-O0")
set(ENV{RELEASE_OPTIONS} "-O3;-Werror")

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  add_compile_options($ENV{COMPILE_OPTIONS} $ENV{DEBUG_OPTIONS})
  add_compile_definitions(NDEBUG)
else()
  add_compile_options($ENV{COMPILE_OPTIONS} $ENV{RELEASE_OPTIONS})
endif()

include(DefinePlatformDefaults.cmake)

# Build options
option(ENABLE_GROUP "Enable lookup of groups" ON)

# config.h checks
include(ConfigureChecks.cmake)
configure_file(config.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_subdirectory(src)

if (NOT FREEBSD)
add_subdirectory(test)
endif (NOT FREEBSD)

# this needs to be here and not in test/CMakeLists.txt
enable_testing()
add_test(config_helpers_test test/maria_config_helpers_test)
add_test(config_test test/maria_config_test)
add_test(logger_test test/maria_logger_test)
# add_test(integration_nss_test test/integration/nss_module)
