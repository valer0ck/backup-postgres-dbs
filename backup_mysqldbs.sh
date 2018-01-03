#!/bin/sh

# Script to backup mysql dbs. user and password are root

current_date=`date +\%Y-\%m-\%d`
mkdir -p /home/mysql_backups/$current_date

dbs=`mysql --user=root --password=root -e 'show databases' | grep -v Database`

for i in $dbs; do
    if [ $i != "information_schema" ] && [ $i != "performance_schema" ] && [ $i != "mysql" ] && [ $i != "sys" ]; then
        `mysqldump --user=root --password=root $i > /home/mysql_backups/$current_date/$i.sql`
    fi
done

zip -r /home/mysql_backups/$current_date/$current_date.zip /home/mysql_backups/$current_date
echo "Dbs backup" | mutt  -s "Dbs backup" hi@elementalab.com -a /home/mysql_backups/$current_date/$current_date.zip

# Delete zip folder with backups after 15 days
days_ago_15=$(date +%Y-%m-%d -d "$current_date - 15  day")
rm -rf /home/mysql_backups/$days_ago_15
