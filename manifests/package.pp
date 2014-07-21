# Class: burp::package
#
# PPA from https://launchpad.net/~bas-dikkenberg/+archive/burp-latest

class burp::package{

  if $::operatingsystem != 'Ubuntu' {
    fail('Operatingsystem not supported yet')
  }

  ensure_resource('file', 'sources.list.d', {
      'ensure' => 'directory',
      'path'   => '/etc/apt/sources.list.d'
    }
  )

  apt::ppa { 'ppa:bas-dikkenberg/burp-latest':
    require => File['/etc/apt/sources.list.d']
  }

  if ($lsbdistrelease == "13.04") or ($lsbdistrelease == "14.04") {
    $packagename = '1.4.12-1ubuntu5'
  } else {
    $packagename = '1.4.12-1ubuntu2'
  }

  apt::key {'ppa:bas-dikkenberg/burp-latest':
    key         => '31287BA1',
    key_server  => 'keyserver.ubuntu.com',
    require     => File['/etc/apt/sources.list.d']
  }

  package { 'burp':
    ensure => $packagename,
    require => [Apt::Ppa['ppa:bas-dikkenberg/burp-latest'], Apt::Key['ppa:bas-dikkenberg/burp-latest']]
  }
}
