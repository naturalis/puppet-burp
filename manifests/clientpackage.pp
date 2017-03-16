# Class: burp::package-burp-client
#

class burp::clientpackage{

  if $::operatingsystem != 'Ubuntu' {
    notice('Operatingsystem not supported, perform manual burp installation.')
  }

  if $::operatingsystem == 'Ubuntu' {

    if !defined(Class['apt']) {
      class { 'apt': }
    }

    apt::source { 'ziirish':
      location => 'http://ziirish.info/repos/ubuntu/xenial/',
      release  => 'zi-stable',
      repos    => 'main',
      key      => { 
        'id'     => '3F154A9DA875B6C613214D609EBCB6DB11260BA7',
        'server' => 'keyserver.ubuntu.com'
      }
    }

    apt::key {'ziirish':
        id     => '3F154A9DA875B6C613214D609EBCB6DB11260BA7',
        server => 'keyserver.ubuntu.com'
    }

    exec { 'for_burp_apt_get_update':
      command     => 'apt-get update',
      cwd         => '/tmp',
      path        => ['/usr/bin'],
      require     => Apt::Source['ziirish'],
      subscribe   => Apt::Source['ziirish'],
      refreshonly => true,
    }

    package { 'burp-client':
      ensure   => latest,
      install_options => ['--allow-unauthenticated', '-f'],
      require  => Exec['for_burp_apt_get_update']
    }
  }


}
