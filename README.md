## Running (development)

* Requires a Linux or Mac.
* Requires Ruby 3.2.x or higher
* Requires Postgres SQL (look in config/database.yml for the user role needed)
* `bin/bundle install
* `RAILS_ENV=production bin/rake db:create:all db:migrate`
* `RAILS_ENV=production bin/rake assets:clobber assets:precompile`
* `RAILS_ENV=production bin/rails server`
* For SSL `RAILS_ENV=production bin/bundle exec puma -b 'ssl://0.0.0.0:9292?key=server.key&cert=server.crt'`

## Postgres SQL extension

Log into the database and enter the following command to enable a needed extension for fuzzy searches:

    CREATE EXTENSION PG_TRGM;

## Badge printing handling

* Relies on cups being installed (on Linux):
  * Configure default printer's IP address in _/etc/cups/printers.conf_
  * Restart cups (`sudo service cups restart`)

Some useful commands to control the printing service in Linux:
* Enable the printer: `sudo lpadmin -E lp7`
* Clear the printing queue: `sudo lprm - -P lp7` (The _lp7_ id of the printer can vary)
* Verify remote printer's state: `lpstat -a`

To pause badge printing service:

    touch noprint # From the rails root directory

To reenable badge printing service:

    rm noprint # From the rails root directory

To see application printing logs

    tail -f log/printing.log

## Backing up the database

```
$ pg_dump --encoding UTF8 --inserts registroibpr > registro_dump.date-here.sql
$ gzip registro_dump.date-here.sql
```

## Restoring the database

```
$ gunzip registro_dump.date-here.sql.gz
$ psql registroibpr < registro_dump.date-here.sql
```

## To reset data before opening registry for new event
```
$ psql registroibpr
# delete from checks;
# delete from people where role != 2;
# update people set attended=false, printed=false, materials=false;
# \q
```

# References

* https://developers.hp.com/hp-linux-imaging-and-printing/install/step4/cups/local
* https://www.cups.org/doc/admin.html
* https://docs.oracle.com/cd/E23824_01/html/821-1451/gllgm.html#gllfr
