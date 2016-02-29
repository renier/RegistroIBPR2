## Running (development)

* Requires a Linux or Mac.
* Requires Ruby 2.1.x
* Requires PosgreSQL (look in config/database.yml for the user role needed)
* `bundle install --path vendor/bundle`
* `bundle exec rake db:migrate`
* `bundle exec rails s`

## Badge printing handling

* Relies on cups being installed.
* Configure default printer's IP address in _/etc/cups/printers.conf_
* Restart cups (`sudo service cups restart`)

Some useful commands to control the printing service in Linux:
* Clear the printing queue: `sudo lprm - -P lp7` (The _lp7_ id of the printer can vary)
* Verify remote printer's state: `lpstat -a`

To pause badge printing service:

    touch noprint # From the rails root directory

To reenable badge printing service:

    rm noprint # From the rails root directory