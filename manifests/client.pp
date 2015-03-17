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
  $cron             = undef,
){

  host { $::hostname:
    ensure       => 'present',
    host_aliases => [$::hostname, 'localhost'],
    ip           => '127.0.0.1',
    target       => '/etc/hosts',
  }

  file { '/etc/burp/burp.conf':
    ensure  => present,
    mode    => '600',
    content => template("burp/burp.conf.erb"),
    require => Class['burp::package']
  }

  if ($cron == true){
    cron { 'initiate backup':
      command => '/usr/sbin/burp -a t',
      user    => root,
      minute  => '*/20',
    }
  }

  # Create client config file on server with exported resource
  @@file { "/etc/burp/clientconfdir/${cname}":
    mode    => "600",
    content => template('burp/clientconf.erb'),
    tag     => 'burpclient-0f3fa71c-0d38-4249-aecb-52efa966627c',
  }


}
