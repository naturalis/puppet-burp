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

    package { 'burp-server':
      ensure   => latest,
      install_options => ['--allow-unauthenticated', '-f'],
      require  => Apt::Source['ziirish']
    }
  }


}
