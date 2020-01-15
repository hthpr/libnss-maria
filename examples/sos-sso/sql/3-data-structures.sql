-- MySQL dump 10.15  Distrib 10.0.24-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: sos-sso-production
-- ------------------------------------------------------
-- Server version 10.0.24-MariaDB-1~jessie

--
-- Table structure for table `groups`
--

CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'x',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unqname` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8041 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `groups_users`
--

CREATE TABLE `groups_users` (
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  KEY `index_groups_users_on_group_id_and_user_id` (`group_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `gid` bigint(20) NOT NULL,
  `gecos` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `homedir` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `shell` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '/usr/bin/rssh',
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'x',
  `lstchg` bigint(20) NOT NULL DEFAULT '1',
  `min` bigint(20) NOT NULL DEFAULT '0',
  `max` bigint(20) NOT NULL DEFAULT '9999',
  `warn` bigint(20) NOT NULL DEFAULT '30',
  `inact` bigint(20) NOT NULL DEFAULT '0',
  `expire` bigint(20) NOT NULL DEFAULT '-1',
  `flag` tinyint(4) NOT NULL DEFAULT '0',
  `quota_mass` bigint(20) NOT NULL DEFAULT '52428800',
  `quota_inodes` bigint(20) NOT NULL DEFAULT '15000',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ntlm_password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unqusername` (`username`),
  KEY `index_users_on_active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=8000 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
