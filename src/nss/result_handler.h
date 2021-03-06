#ifndef MARIA_NSS_RESULT_HANDLER_H
#define MARIA_NSS_RESULT_HANDLER_H
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stddef.h>
#include <errno.h>
#include <nss.h>
#include <pwd.h>
#ifdef HAVE_SHADOW_H
#include <shadow.h>
#endif
#ifdef HAVE_GROUP
#include <grp.h>
#endif
#include <mysql.h>
#include "config.h"

enum nss_status copy_db_row_to_passwd(MYSQL_ROW row, struct passwd *passwd_result, char *buffer, size_t buflen, unsigned int fields, int *errnop);
#ifdef HAVE_SHADOW_H
enum nss_status copy_db_row_to_shadow(MYSQL_ROW row, struct spwd *shadow_result, char *buffer, size_t buflen, int *errnop);
#endif
#ifdef HAVE_GROUP
enum nss_status copy_db_row_to_group(
  MYSQL_ROW row,
  struct group *group_result,
  char *buffer,
  size_t buflen,
  size_t *occupied_buffer,
  int *errnop
);
enum nss_status copy_group_members_to_group(
  MYSQL_RES *members_query_result,
  struct group *group_result,
  char *buffer,
  size_t buflen,
  size_t *occupied_buffer,
  int *errnop
);
enum nss_status copy_gids(
  MYSQL_RES *result,
  long int *start_index,
  long int *gids_size,
  gid_t **gids,
  long int limit,
  int *errnop
);
#endif /* HAVE_GROUP */

#define CLEANUP() \
  if(settings != NULL) free(settings);\
  if(result != NULL) mysql_free_result(result);\
  if(conn != NULL) mysql_close(conn);

#define READ_USER_CONFIG(errnop) \
  if(maria_read_config_file(settings, "/etc/libnss-maria.conf") > 0) {\
    free(settings);\
    *errnop = ENOENT;\
    return NSS_STATUS_UNAVAIL;\
  }

#endif
