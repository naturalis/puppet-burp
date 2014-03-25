# Class: burp::client
#
#
class burp::client {

  host { $::fqdn:
    ensure       => 'present',
    host_aliases => [$::hostname],
    ip           => $::ipaddress,
    target       => '/etc/hosts',
  }

  file { '/etc/burp/burp.conf':
    ensure  => present,
    mode    => '600',
    content => template("burp/burp.conf.erb"),
    require => Package['burp']
  }

}