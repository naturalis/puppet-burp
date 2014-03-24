# Class: burp::server
#
#
class burp::server (
  
  $clientconf_hash = clientconf_hash,
  
) {

  $directory           = $::directory
  $max_children        = $::max_children
  $max_status_children = $::max_status_children
  $keep                = $::keep
  $waittime            = $::waittime
  $starttime           = $::starttime
  
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