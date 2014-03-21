# Class: burppackage
#
# PPA from https://launchpad.net/~bas-dikkenberg/+archive/burp-latest

class burppackage {

  if $::operatingsystem != 'Ubuntu' {
    fail('This module only works on Ubuntu')
  }

  file { '/etc/apt/sources.list.d':
    ensure => 'directory',
  }

  apt::ppa { 'ppa:bas-dikkenberg/burp-latest':
    require => File['/etc/apt/sources.list.d']
  }

  package { 'burp':
    ensure => '1.4.10-1ubuntu2',
    require => Apt::Ppa['ppa:bas-dikkenberg/burp-latest']
  }
}
