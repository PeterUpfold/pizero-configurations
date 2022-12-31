     $ wget https://files.cacti.net/cacti/linux/cacti-1.2.22.tar.gz

     $ wget https://files.cacti.net/spine/cacti-spine-1.2.22.tar.gz

Extract:

     $ tar xzvf cacti-1.2.22.tar.gz
     $ tar xzvf cacti-spine-1.2.22.tar.gz

Remove `include/config.php`

     $ rm cacti-1.2.22/include/config.php

Backup 

     $ sudo tar --same-owner -czpvf /home/peter/cacti-preupg.tar.gz /var/www/cacti/

Update files
     $ sudo rsync -rvh cacti-1.2.22/ /var/www/cacti/

Visit page at http://ipaddress/cacti/install

Spine:

     $ cd cacti-spine-1.2.22
     $ ./bootstrap
     $ ./configure --with-mysql=/usr/include/mariadb
     $ make
     $ sudo make install