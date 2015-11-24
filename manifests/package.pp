# Class: burp::package
#
# PPA from https://launchpad.net/~bas-dikkenberg/+archive/burp-latest

class burp::package{

  if $::operatingsystem != 'Ubuntu' {
    notice('Operatingsystem not supported, perform manual burp installation.')
  }

  if $::operatingsystem == 'Ubuntu' {

    if !defined(Class['apt']) {
      class { 'apt': }
    }

    apt::ppa { 'ppa:hugo-vanduijn/burp-latest':
      require => File['/etc/apt/sources.list.d']
    }

    apt::key {'ppa:hugo-vanduijn/burp-latest':
      id          => 'A3C9CD9651B55C62714BB57F33B09D29A4EF7A24',
      server      => 'keyserver.ubuntu.com',
      require     => File['/etc/apt/sources.list.d']
    }

    package { 'burp':
      ensure   => latest,
      require  => [Apt::Ppa['ppa:hugo-vanduijn/burp-latest'], Apt::Key['ppa:hugo-vanduijn/burp-latest']]
    }
  }


}
