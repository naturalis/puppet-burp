# Class: burp::client
#
#
class burp::client (
  $includes         = undef,
  $excludes         = undef,
  $cname            = undef,
  $options          = undef,
  $password         = undef,
  $client_password  = undef,
){

  host { $::hostname:
    ensure       => 'present',
    host_aliases => [$::hostname, 'localhost'],
    ip           => '127.0.0.1',
    target       => '/etc/hosts',
  }

  file { '/etc/burp/burp.conf':
    ensure  => present,
    mode    => '0600',
    content => template('burp/burp.conf.erb'),
    require => Class['burp::clientpackage']
  }

  if ($burp::cron == 'true'){
    file { '/var/log/burp':
      ensure  => directory,
      mode    => '0755',
    }
    cron { 'initiate backup':
      command => '/usr/sbin/burp -a t >> /var/log/burp/burp.log',
      user    => root,
      hour    => $burp::cronhour,
      minute  => $burp::cronminute
    }
    file { '/etc/logrotate.d/burpcron':
      ensure  => present,
      mode    => '0644',
      content => template('burp/logrotate_burpcron.erb'),
    }

  }

  # Create client config file on server with exported resource
  @@file { "/etc/burp/clientconfdir/${burp::client::cname}":
    mode    => '0600',
    content => template('burp/clientconf.erb'),
    tag     => 'burpclient-0f3fa71c-0d38-4249-aecb-52efa966627c',
  }


}
