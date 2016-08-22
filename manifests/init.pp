# == Class: burp
#
#
# === Authors
#
# Author Name rudi.broekhuizen@naturalis.nl
#

class burp (
# general settings
  $mode             = 'server',
  $ssl_key_password = 'password',

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

# server: autoupdate (Windows 64 bit only), put file in files 
  $autoupgrade            = true,
  $autoupgradeversion     = '1.4.40',
  $autoupgradefilename    = 'burp-win64-installer-1.4.40.exe',

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
) {

include burp::package

  if $mode == 'server' {
    if $chkbackup == true {
        create_resources('burp::chkbackup', $chkbackup_hash)
    }
    class {'burp::server':
      clientconf_hash       => $clientconf_hash,
      common_clientconfig   => $common_clientconfig,
    }
    if $autoupdate == true {
      exec {'autoupgradedir':
        command           => "mkdir -p /etc/burp/autoupgrade/server/win64/${autoupgradeversion}",
        path              => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
        unless            => "/usr/bin/test -d /etc/burp/autoupgrade/server/win64/${autoupgradeversion}",
        require           => Class['burp::server']
      }
      file { "/etc/burp/autoupgrade/server/win64/script":
        ensure            => present,
        source            => 'puppet:///modules/burp/script',
        owner             => 'root',
        group             => 'root',
        mode              => '0644',
        require           => Exec['autoupgradedir']
      }
      file { "/etc/burp/autoupgrade/server/win64/${autoupgradeversion}/package":
        ensure            => present,
        source            => "puppet:///modules/burp/${autoupgradefilename}",
        owner             => 'root',
        group             => 'root',
        mode              => '0644',
        require           => Exec['autoupgradedir']
      }
    }
  } elsif $mode == 'client' {
      class {'burp::client':
        includes        => $includes,
        excludes        => $excludes,
        options         => $options,
        password        => $password,
        client_password => $client_password,
        cname           => $cname,
        cron            => $cron,
      }

    } else {
        fail('unknown mode')
  }

}