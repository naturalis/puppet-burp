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
  
  apt::ppa { 'ppa:bas-dikkenberg/burp-latest':
    require => File['/etc/apt/sources.list.d']
  }

  if ($lsbdistrelease == "13.04") or ($lsbdistrelease == "13.10") {
    $packagename = '1.4.10-1ubuntu1'
  } else {
    $packagename = '1.4.10-1ubuntu2'
  }
  
  package { 'burp':
    ensure => $packagename,
    require => Apt::Ppa['ppa:bas-dikkenberg/burp-latest']
  }
}
