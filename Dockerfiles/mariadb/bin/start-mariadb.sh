#!/bin/bash
echo "Executing install db"
mysql_install_db --user mysql > /dev/null
sleep 5s
echo "starting mysql db"
mysqld_safe --user mysql &
sleep 5s
