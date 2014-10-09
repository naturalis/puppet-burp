# Class: burp::package
#
# PPA from https://launchpad.net/~bas-dikkenberg/+archive/burp-latest

class burp::package{

  if $::operatingsystem != 'Ubuntu' {
    fail('Operatingsystem not supported yet')
  }

  ensure_resource('file', '/etc/apt/sources.list.d', {
      'ensure' => 'directory'
    }
  )
  
  apt::ppa { 'ppa:hugo-vanduijn/burp-latest':
    require => File['/etc/apt/sources.list.d']
  }
  
  package { 'burp':
    ensure => latest,
    require => Apt::Ppa['ppa:hugo-vanduijn/burp-latest']
  }
}
