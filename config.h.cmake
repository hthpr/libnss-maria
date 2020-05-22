/* Name of package */
#cmakedefine PACKAGE "${PROJECT_NAME}"

/* Version number of package */
#cmakedefine VERSION "${PROJECT_VERSION}"

#cmakedefine LOCALEDIR "${LOCALE_INSTALL_DIR}"
#cmakedefine DATADIR "${DATADIR}"
#cmakedefine LIBDIR "${LIBDIR}"
#cmakedefine PLUGINDIR "${PLUGINDIR}"
#cmakedefine SYSCONFDIR "${SYSCONFDIR}"
#cmakedefine BINARYDIR "${BINARYDIR}"
#cmakedefine SOURCEDIR "${SOURCEDIR}"

/************************** HEADER FILES *************************/

#cmakedefine HAVE_SYS_TYPES_H 1
#cmakedefine HAVE_PWD_H 1
#cmakedefine HAVE_SHADOW_H 1
#cmakedefine HAVE_GRP_H 1
#cmakedefine HAVE_NSS_H 1
#cmakedefine HAVE_NSS_COMMON_H 1

/*************************** FUNCTIONS ***************************/

/* Define to 1 if you have the `getpwnam_r' function. */
#cmakedefine HAVE_GETPWNAM_R 1

/* Define to 1 if you have the `getpwuid_r' function. */
#cmakedefine HAVE_GETPWUID_R 1

/* Define to 1 if you have the `getpwent_r' function. */
#cmakedefine HAVE_GETPWENT_R 1

/* Define to 1 if you have the `setspent' function. */
#cmakedefine HAVE_SETSPENT 1

/* Define to 1 if you have the `getspnam' function. */
#cmakedefine HAVE_GETSPNAM 1

/* Define to 1 if you have the `getgrnam_r' function. */
#cmakedefine HAVE_GETGRNAM_R 1

/* Define to 1 if you have the `getgrgid_r' function. */
#cmakedefine HAVE_GETGRGID_R 1

/* Define to 1 if you have the `getgrent_r' function. */
#cmakedefine HAVE_GETGRENT_R 1

/* Define to 1 if you have the `getgrouplist' function. */
#cmakedefine HAVE_GETGROUPLIST 1

#cmakedefine HAVE_GETPROGNAME 1
#cmakedefine HAVE_GETEXECNAME 1

#cmakedefine HAVE___POSIX_GETPWNAM_R 1
#cmakedefine HAVE___POSIX_GETPWUID_R 1

#cmakedefine HAVE___POSIX_GETGRGID_R 1
#cmakedefine HAVE___POSIX_GETGRNAM_R 1

/*************************** LIBRARIES ***************************/

#cmakedefine HAVE_LIBNSL 1
#cmakedefine HAVE_LIBSOCKET 1

/**************************** OPTIONS ****************************/

#cmakedefine HAVE_SOLARIS_GETPWENT_R 1
#cmakedefine HAVE_SOLARIS_GETPWNAM_R 1
#cmakedefine HAVE_SOLARIS_GETPWUID_R 1
#cmakedefine HAVE_SOLARIS_GETGRENT_R 1
#cmakedefine HAVE_SOLARIS_GETGRNAM_R 1
#cmakedefine HAVE_SOLARIS_GETGRGID_R 1
#cmakedefine HAVE_SOLARIS_SETHOSTENT 1
#cmakedefine HAVE_SOLARIS_ENDHOSTENT 1
#cmakedefine HAVE_SOLARIS_GETHOSTNAME 1
#cmakedefine HAVE_BSD_SETGRENT 1
#cmakedefine HAVE_LINUX_GETNAMEINFO 1
#cmakedefine HAVE_LINUX_GETNAMEINFO_UNSIGNED 1
#cmakedefine HAVE_GETADDRINFO_SETS_CANONNAME_FOR_IPADDRESSES 1
#cmakedefine HAVE_GETADDRINFO_USES_EAI_SERVICE 1
#cmakedefine HAVE_NONNULL_GETHOSTENT 1

#cmakedefine HAVE_STRUCT_SOCKADDR_SA_LEN 1
#cmakedefine HAVE_STRUCT_PASSWD_PW_CLASS 1
#cmakedefine HAVE_STRUCT_PASSWD_PW_CHANGE 1
#cmakedefine HAVE_STRUCT_PASSWD_PW_EXPIRE 1

#cmakedefine HAVE_IPV6 1

#cmakedefine HAVE_ATTRIBUTE_PRINTF_FORMAT 1
#cmakedefine HAVE_CONSTRUCTOR_ATTRIBUTE 1
#cmakedefine HAVE_DESTRUCTOR_ATTRIBUTE 1

