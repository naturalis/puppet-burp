# Class: burp::server
#
#
class burp::server (
  
  $clientconf_hash = clientconf_hash,
  
) {

  file { '/etc/burp/clientconfdir':
    ensure     => 'directory',
    require    => Package['burp']
  }

  file { '/etc/burp/burp-server.conf':
    ensure  => present,
    mode    => '600',
    content => template("burp/burp-server.conf.erb"),
    require => Package['burp']
  }

  service { 'burp':
    ensure  => 'running',
    require => File['/etc/burp/burp-server.conf'] 
  }

  create_resources('burp::clientconf', $clientconf_hash)

}
