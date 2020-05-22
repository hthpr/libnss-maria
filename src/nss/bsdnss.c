/*
   bsdnss.c - BSD NSS functions
   This file was part of the nss-pam-ldapd FreeBSD port and part of the
   nss_ldap FreeBSD port before that
   adapted for libnss-maria by Michael Tratz

   Copyright (C) 2003 Jacques Vidrine
   Copyright (C) 2006 Artem Kazakov
   Copyright (C) 2009 Alexander V. Chernikov
   Copyright (C) 2011-2016 Arthur de Jong
   Copyright (C) 2011 Tom Judge

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
   02110-1301 USA
*/

#include "config.h"
#include "passwd.h"
#include "group.h"

/* FreeBSD specific register function */
ns_mtab *nss_module_register(const char *source, unsigned int *mtabsize,
                             nss_module_unregister_fn *unreg);

NSS_METHOD_PROTOTYPE(__nss_compat_getgrnam_r);
NSS_METHOD_PROTOTYPE(__nss_compat_getgrgid_r);
NSS_METHOD_PROTOTYPE(__nss_compat_getgrent_r);
NSS_METHOD_PROTOTYPE(__nss_compat_setgrent);
NSS_METHOD_PROTOTYPE(__nss_compat_endgrent);

NSS_METHOD_PROTOTYPE(__nss_compat_getpwnam_r);
NSS_METHOD_PROTOTYPE(__nss_compat_getpwuid_r);
NSS_METHOD_PROTOTYPE(__nss_compat_getpwent_r);
NSS_METHOD_PROTOTYPE(__nss_compat_setpwent);
NSS_METHOD_PROTOTYPE(__nss_compat_endpwent);

static ns_mtab methods[] = {
  { NSDB_GROUP, "getgrnam_r", __nss_compat_getgrnam_r, (void *)_nss_maria_getgrnam_r },
  { NSDB_GROUP, "getgrgid_r", __nss_compat_getgrgid_r, (void *)_nss_maria_getgrgid_r },
  { NSDB_GROUP, "getgrent_r", __nss_compat_getgrent_r, (void *)_nss_maria_getgrent_r },
  { NSDB_GROUP, "setgrent",   __nss_compat_setgrent,   (void *)_nss_maria_setgrent },
  { NSDB_GROUP, "endgrent",   __nss_compat_endgrent,   (void *)_nss_maria_endgrent },

  { NSDB_PASSWD, "getpwnam_r", __nss_compat_getpwnam_r, (void *)_nss_maria_getpwnam_r },
  { NSDB_PASSWD, "getpwuid_r", __nss_compat_getpwuid_r, (void *)_nss_maria_getpwuid_r },
  { NSDB_PASSWD, "getpwent_r", __nss_compat_getpwent_r, (void *)_nss_maria_getpwent_r },
  { NSDB_PASSWD, "setpwent",   __nss_compat_setpwent,   (void *)_nss_maria_setpwent },
  { NSDB_PASSWD, "endpwent",   __nss_compat_endpwent,   (void *)_nss_maria_endpwent },

};

ns_mtab *nss_module_register(const char *source, unsigned int *mtabsize,
                             nss_module_unregister_fn *unreg)
{
  *mtabsize = sizeof(methods) / sizeof(methods[0]);
  *unreg = NULL;
  return methods;
}
