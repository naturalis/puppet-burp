# == Class: burp
#
# Full description of class burp here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { burp:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name rudi.broekhuizen@naturalis.nl
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#

class burp (
# general settings
  $mode             = "client",
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

# server: settings for /etc/burp-server.conf 
  $directory           = "/mnt/backup/burpdata",
  $max_children        = "25",
  $max_status_children = "25",
  $keep                = "60",
  $waittime            = "20",
  $starttime           = "Mon,Tue,Wed,Thu,Fri,Sat,Sun,00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23",
 
# server: create client config files in /etc/clientconfdir for Windows clients
  $clientconf_hash     = { 'servername-01.domain' => { includes => ['C:/', 'D:/'],
                                                       excludes => ['D:/$RECYCLE.BIN/'],
                                                       options  => ['options-nnms00'],
                                                       password => 'password',
                                                     },
                         
                           'servername-02.domain' => { includes => ['C:/', 'D:/'],
                                                       excludes => ['D:/$RECYCLE.BIN/'],
                                                       options  => ['options-nnms01'],
                                                       password => 'password',
                                                     },
                         },
) {
  
include burp::package

  if $mode == "server" {
    class {'burp::server':
      clientconf_hash => $clientconf_hash, 
    }
      
  } elsif $mode == "client" {
      class {'burp::client':
      }

    } else {
        fail("unknown mode")
  }

}
