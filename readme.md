# Backing up PostgreSQL databases

Script for generating postgres databases backup. Backups are compressed to zip file and send them to and email everyday.

Dbs backup (sql) and compressed files remain at server for 15 days, script also delete them.

### Requirements

Sending email from server require to install

```
sudo apt-get install postfix
sudo apt-get install mutt
sudo apt install mailutils
```

[mutt], command line email client. Mutt allows you to send attachments

Most email services receive emails from a limited size, for example gmail only allows less than 25 MB

[postfix], Mail Transfer Agent, restrict attachments size to 10MB, to increase attachments size  to 50MB type:

```
postconf -e message_size_limit=52428800
```

To check size limit type:

```
postconf | grep message_size_limit
```

Then:

```
sudo service postfix restart
```

### Adding cronjob

Open crontab list with

```
 crontab -e
```

Then add your cronjob:

```
0 2 * * * /bin/sh /home/backup_folder/backup.sh >> /home/django/backup/log.log 2>&1
```

Cronjob will be executed everyday at 2:00 am. There is also created a logfile in backup folder

### Code

If you are testing at localhost, postgres_host='localhost' other case postgres_host=''

You also need to update:
postgres_password, postgres_username and to email (hi@elementalab.com)

### Mysql

There where added a script to generate mysql backup similar to postgres backup


[mutt]: <http://www.mutt.org/>
[postfix]:<https://help.ubuntu.com/community/Postfix>
