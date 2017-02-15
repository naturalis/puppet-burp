puppet-burp
====================

Manage Burp2, backup and restore program

Install and configure server or client. Create scripts usable for monitoring backup and exports the scripts as sensu checks. 


Parameters
-------------
All parameters are read from defaults in init.pp and can be overwritten by hiera or The foreman.


General settings:

```
# general settings
  $mode             = "server",
  $ssl_key_password = "password",

# client: settings for /etc/burp/burp.conf
  $server             = '127.0.0.1',
  $client_password    = 'password',
  $cname              = $hostname,
  $server_can_restore = '1',

# client: create client config files in /etc/clientconfdir for Linux clients
  $includes               = '/home',
  $excludes               = '/tmp',
  $options                = '',
  $password               = 'password',
  $cron                   = true,
  $backup_script_pre      = '',

# server: autoupdate (Windows 64 bit only), put file in files.
  $autoupgrade            = true,
  $autoupgradeversion     = '2.0.54',
  $autoupgradefilename    = 'burp-win64-installer-2.0.54.exe',

# server: settings for /etc/burp-server.conf
  $directory             = '/mnt/backup/burpdata',
  $max_children          = '25',
  $max_status_children   = '25',
  $keep                  = '70',
  $waittime              = '20h',
  $starttime             = 'Mon,Tue,Wed,Thu,Fri,Sat,Sun,00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23',
  $common_clientconfig   = ['working_dir_recovery_method=resume'],
  $backup_stats_logstash = true,

# server: create client config files in /etc/clientconfdir for Windows clients
  $clientconf           = false,
  $clientconf_hash      = { 'servername-01.domain' => { password => 'password'},
                            'servername-02.domain' => { password => 'password'}
                          },

# server: create sensu checks for server based backup monitoring, warning and critical hours adjustable per client
  $chkbackup            = false,
  $chkbackup_hash       = { 'testclient1' => { 'chkwarninghours' => '24', 'chkcriticalhours' => '48' },
                            'testclient2' => { 'chkwarninghours' => '24', 'chkcriticalhours' => '48' }
                          },

```

To add clients using puppet, create a hash with settings: 


```
$clientconf_hash     = { 'servername-01.domain' => { password => 'password',
                                                   },
                         'servername-02.domain' => { password => 'password',
                                                   },
                       },
```


Classes
-------------
* burp
* burp::package
* burp::server
* burp::client
* burp::clientconf
* burp::chkbackup

Dependencies
-------------
* puppetlabs/apt


Limitations
-------------
This module has been built on and tested against Puppet 4 and higher. Burp package installation is supported on Ubuntu operating systems, install Burp manually on other operating systems. 


The module has been tested on:
* Ubuntu 16.04LTS

Authors
-------------
* [Rudi Broekhuizen](rudi.broekhuizen@naturalis.nl)
* [Hugo van Duijn](mailto:hugo.vanduijn@naturalis.nl)
