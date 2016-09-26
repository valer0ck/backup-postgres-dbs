#!/bin/sh

postgres_password='your-postgres-password'
postgres_username='your-postgres-username'
# If you are testing at localhost, postgres_host='localhost' other case = ''
postgres_host=''
current_date=`date +\%Y-\%m-\%d`
mkdir -p /home/postgres_bkp/$current_date

ls -t *.sql | sed -e '1,13d' | xargs -d '\n' rm -f
dbs=`PGPASSWORD=$postgres_password psql --username=$postgres_username --host=$postgres_host -l -t | cut -d'|' -f1 | sed -e 's/ //g' -e '/^$/d'`

for i in $dbs; do
    if [ "$i" != "template0" ] && [ "$i" != "template1" ]; then
        PGPASSWORD=$postgres_password pg_dump $i --username=$postgres_username --host=$postgres_host > /home/postgres_bkp/$current_date/$i.sql
    fi
done

zip -r /home/postgres_bkp/$current_date/$current_date.zip /home/postgres_bkp/$current_date
echo "Dbs backup" | mutt  -s "Dbs backup" hi@elementalab.com -a /home/postgres_bkp/$current_date/$current_date.zip

# Delete zip folder with backups after 15 days
days_ago_15=$(date +%Y-%m-%d -d "$current_date - 15  day")
rm -rf /home/postgres_bkp/$days_ago_15
