USE mysql;
CREATE DATABASE IF NOT EXISTS mediawiki CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'mediawiki' IDENTIFIED BY 'mediawiki123$';
grant all privileges on mediawiki.* TO 'mediawiki'@'localhost' identified by 'mediawiki123$';
FLUSH PRIVILEGES;