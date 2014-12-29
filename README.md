puppet-burp
====================

Manage Burp, backup and restore program



Parameters
-------------
All parameters are read from defaults in init.pp and can be overwritten by hiera or The foreman.

General settings:

```
# general settings
  $mode             = "server",
  $ssl_key_password = "password",

# client: settings for /etc/burp/burp.conf
  $server             = "127.0.0.1",
  $client_password    = "password",
  $cname              = $fqdn,
  $server_can_restore = "1",

# client: create client config files in /etc/clientconfdir for Linux clients
  $includes = "/home",
  $excludes = "/tmp",
  $options  = "",
  $password = "password",
  $cron     = true,

# server: settings for /etc/burp-server.conf 
  $directory           = "/mnt/backup/burpdata",
  $max_children        = "25",
  $max_status_children = "25",
  $keep                = "60",
  $waittime            = "20",
  $starttime           = "Mon,Tue,Wed,Thu,Fri,Sat,Sun,00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23",
  $common_clientconfig = ['working_dir_recovery_method=resume'],
```

To add Windows clients, create a hash with settings:


```
$clientconf_hash     = { 'servername-01.domain' => { includes => ['C:/', 'D:/'],
                                                     excludes => ['D:/$RECYCLE.BIN/'],
                                                     options  => ['options'],
                                                     password => 'password',
                                                   },
                         
                         'servername-02.domain' => { includes => ['C:/', 'D:/'],
                                                     excludes => ['D:/$RECYCLE.BIN/'],
                                                     options  => ['options'],
                                                     password => 'password',
                                                   },
                       },
```


Classes
-------------
burp
brup::package
burp::server
burp::client
burp::clientconf


Dependencies
-------------
puppetlabs/apt


Limitations
-------------
This module has been built on and tested against Puppet 3 and higher. Burp package installation is supported on Ubuntu operating systems, install Burp manually on other operating systems. 


The module has been tested on:
- 
Ubuntu 12.04LTS
Ubuntu 14.04LTS

Authors
-------------
Author Name <rudi.broekhuizen@naturalis.nl>

