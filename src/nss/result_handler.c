#include "result_handler.h"

enum nss_status copy_db_row_to_passwd(MYSQL_ROW row, struct passwd *passwd_result, char *buffer, size_t buflen, unsigned int fields, int *errnop) {
  size_t username_l = strlen(row[0]);
  size_t password_l = strlen(row[1]);
  size_t gecos_l = strlen(row[4]);
  size_t homedir_l = strlen(row[5]);
  size_t shell_l = strlen(row[6]);
  size_t class_l = 0;

#ifdef HAVE_STRUCT_PASSWD_PW_CLASS
  if (fields > 7)
    class_l = strlen(row[7]);
#endif

  if (username_l + password_l + gecos_l + homedir_l + shell_l + class_l + 5 > buflen) {
    *errnop = ERANGE;
    return NSS_STATUS_TRYAGAIN;
  }

  memset(buffer, 0, buflen);

  char *username_buf = buffer;
  char *password_buf = buffer + username_l + 1;
  char *gecos_buf = password_buf + password_l + 1;
  char *homedir_buf = gecos_buf + gecos_l + 1;
  char *shell_buf = homedir_buf + homedir_l + 1;

  strncpy(username_buf, row[0], username_l);
  strncpy(password_buf, row[1], password_l);
  strncpy(gecos_buf, row[4], gecos_l);
  strncpy(homedir_buf, row[5], homedir_l);
  strncpy(shell_buf, row[6], shell_l);

  passwd_result->pw_name = username_buf;
  passwd_result->pw_passwd = password_buf;
  passwd_result->pw_uid = strtoul(row[2], NULL, 10);
  passwd_result->pw_gid = strtoul(row[3], NULL, 10);
  passwd_result->pw_gecos = gecos_buf;
  passwd_result->pw_dir = homedir_buf;
  passwd_result->pw_shell = shell_buf;

#ifdef HAVE_STRUCT_PASSWD_PW_CLASS
  if (fields > 7) {
    char *class_buf = shell_buf + shell_l + 1;
    strncpy(class_buf, row[7], class_l);
    passwd_result->pw_class = class_buf;
  }
#endif

#ifdef HAVE_STRUCT_PASSWD_PW_CHANGE
  if (fields > 8)
    passwd_result->pw_change = strtoul(row[8], NULL, 10);
#endif

#ifdef HAVE_STRUCT_PASSWD_PW_EXPIRE
  if (fields > 9)
    passwd_result->pw_expire = strtoul(row[9], NULL, 10);
#endif

  return NSS_STATUS_SUCCESS;
}

#ifdef HAVE_SHADOW_H
enum nss_status copy_db_row_to_shadow(MYSQL_ROW row, struct spwd *shadow_result, char *buffer, size_t buflen, int *errnop) {
  size_t username_l = strlen(row[0]);
  size_t password_l = strlen(row[1]);

  if (username_l + password_l + 2 > buflen) {
    *errnop = ERANGE;
    return NSS_STATUS_TRYAGAIN;
  }

  memset(buffer, 0, buflen);

  char *username_buf = buffer;
  char *password_buf = buffer + username_l + 1;

  strncpy(username_buf, row[0], username_l);
  strncpy(password_buf, row[1], password_l);

  shadow_result->sp_namp = username_buf;
  shadow_result->sp_pwdp = password_buf;
  shadow_result->sp_lstchg = strtol(row[2], NULL, 10);
  shadow_result->sp_min = strtol(row[3], NULL, 10);
  shadow_result->sp_max = strtol(row[4], NULL, 10);
  shadow_result->sp_warn = strtol(row[5], NULL, 10);
  shadow_result->sp_inact = strtol(row[6], NULL, 10);
  shadow_result->sp_expire = strtol(row[7], NULL, 10);
  shadow_result->sp_flag = strtoul(row[8], NULL, 10);

  return NSS_STATUS_SUCCESS;
}
#endif /* HAVE_SHADOW_H */

#ifdef HAVE_GROUP
enum nss_status copy_db_row_to_group(
  MYSQL_ROW row,
  struct group *group_result,
  char *buffer,
  size_t buflen,
  size_t *occupied_buffer,
  int *errnop
) {
  size_t groupname_l = strlen(row[0]);
  size_t password_l = strlen(row[1]);

  if (groupname_l + password_l + 2 > buflen) {
    *errnop = ERANGE;
    return NSS_STATUS_TRYAGAIN;
  }

  memset(buffer, 0, buflen);

  char *groupname_buf = buffer;
  char *password_buf = buffer + groupname_l + 1;

  strncpy(groupname_buf, row[0], groupname_l);
  strncpy(password_buf, row[1], password_l);
  *occupied_buffer = groupname_l + password_l + 2;

  group_result->gr_name = groupname_buf;
  group_result->gr_passwd = password_buf;
  group_result->gr_gid = strtoul(row[2], NULL, 10);

  return NSS_STATUS_SUCCESS;
}

enum nss_status copy_group_members_to_group(
  MYSQL_RES *members_query_result,
  struct group *group_result,
  char *buffer,
  size_t buflen,
  size_t *occupied_buffer,
  int *errnop
) {
  // buffer: [...occupied, [char* for each member](rows.length+1), [members](rows.length)]
  memset(&(buffer[*occupied_buffer]), 0, buflen - *occupied_buffer);

  my_ulonglong rows_len = mysql_num_rows(members_query_result);
  
  // array of pointers to strings (members)
  #pragma GCC diagnostic ignored "-Wcast-align"
  char **ptr_array = (char**)&(buffer[*occupied_buffer]);
  int ptr_size = sizeof(char*) * (rows_len + 1);
  
  if (*occupied_buffer + ptr_size > buflen) {
    *errnop = ERANGE;
    return NSS_STATUS_TRYAGAIN;
  }

  *occupied_buffer += ptr_size;

  for(my_ulonglong i = 0; i < rows_len; i++) {
    MYSQL_ROW row = mysql_fetch_row(members_query_result);

    if (row == NULL) {
      *errnop = EAGAIN;
      return NSS_STATUS_TRYAGAIN;
    }

    char *name = row[0];
    size_t name_l = strlen(name);

    if (*occupied_buffer + name_l + 1 > buflen) {
      *errnop = ERANGE;
      return NSS_STATUS_TRYAGAIN;
    }

    // TODO: should work, but refactor
    #pragma GCC diagnostic push
#if !defined(__has_warning) || __has_warning("-Wstringop-truncation")
    #pragma GCC diagnostic ignored "-Wstringop-truncation"
#endif
#if !defined(__has_warning) || __has_warning("-Wstringop-overflow")
    #pragma GCC diagnostic ignored "-Wstringop-overflow"
#endif
      strncpy(&(buffer[*occupied_buffer]), name, name_l);
    #pragma GCC diagnostic pop
    ptr_array[i] = &(buffer[*occupied_buffer]);
    *occupied_buffer += name_l + 1;
  }

  group_result->gr_mem = (char **)ptr_array;

  return NSS_STATUS_SUCCESS;
}

enum nss_status copy_gids(
  MYSQL_RES *result,
  long int *start_index,
  long int *gids_size,
  gid_t **gids,
  long int limit,
  int *errnop
) {
  gid_t *group_slots = *gids;
  long int available_gids = *gids_size - *start_index;

  my_ulonglong rows_len = mysql_num_rows(result);
  if (limit > available_gids || (long int)rows_len > available_gids) {
    *errnop = ERANGE;
    return NSS_STATUS_TRYAGAIN;
  }

  for(long int i = *start_index; i < *gids_size; i++) {
    MYSQL_ROW row = mysql_fetch_row(result);

    if (row == NULL) {
      *errnop = EAGAIN;
      return NSS_STATUS_TRYAGAIN;
    }

    group_slots[i] = strtoul(row[0], NULL, 10);
    *start_index += 1;
  }

  return NSS_STATUS_SUCCESS;
}
#endif /* HAVE_GROUP */
