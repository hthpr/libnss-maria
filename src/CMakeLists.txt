cmake_minimum_required (VERSION 3.11)
set (PROJECT_SOURCE_DIR src)
set (PROJECT_BINARY_DIR src)

# find mariadb or mysql
find_package(PkgConfig REQUIRED)
pkg_search_module(MARMYSQL REQUIRED libmariadb libmysqlclient)

if (FREEBSD)
  set(FBSD_SOURCES "nss/bsdnss.c")
endif()

if (HAVE_SHADOW_H)
  set(SHADOW_SOURCES "nss/shadow.c")
endif()

add_library(nss_maria SHARED
  "configuration/maria_config.c"
  "configuration/maria_config_helpers.c"
  "logger/maria_logger.c"
  "nss/passwd.c"
  "nss/group.c"
  "nss/result_handler.c"
  "str_replace.c"
  "mariadb/query.c"
  ${FBSD_SOURCES}
  ${SHADOW_SOURCES}
)

# soname (MAJOR) version must be 2 (probably relates to glibc version, i.e. 2.26).
# soname (MAJOR) version must be 1 on FreeBSD
if (FREEBSD)
  set (nss_maria_VERSION_MAJOR 1)
  set_target_properties(nss_maria PROPERTIES PREFIX "")
else()
  set (nss_maria_VERSION_MAJOR 2)
endif (FREEBSD)

set (nss_maria_VERSION_MINOR 0)
set (nss_maria_VERSION_PATCH 0)
set(nss_maria_VERSION ${nss_maria_VERSION_MAJOR}.${nss_maria_VERSION_MINOR}.${nss_maria_VERSION_PATCH})
set_target_properties(nss_maria PROPERTIES
  VERSION ${nss_maria_VERSION}
  SOVERSION ${nss_maria_VERSION_MAJOR}
)

include_directories(SYSTEM ${MARMYSQL_INCLUDE_DIRS})
target_link_libraries(nss_maria config ${MARMYSQL_LDFLAGS})

add_executable(config_db_settings "util/config_db_settings.c")
target_link_libraries(config_db_settings nss_maria config ${MARMYSQL_LDFLAGS})

install(TARGETS nss_maria LIBRARY DESTINATION lib)
